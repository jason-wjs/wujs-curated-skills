#!/usr/bin/env python3
"""Exercise rendered candidates in disposable directories, without SSH or Codex."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

RENDERER = Path(__file__).resolve().parents[1] / 'skills/engineering/bootstrap-shared-server/scripts/render_profile.py'


class ProfileTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='bootstrap-profile-')
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        # Values containing the old namespace must survive template rendering.
        self.root = self.base / "wjs workspace's files"
        self.root.mkdir()
        self.state = self.root / 'state'
        self.state.mkdir()
        self.binary = self.root / 'fake-codex'
        self.binary.write_text('''#!/usr/bin/env python3
import json, os, sys
print(json.dumps({'cwd': os.getcwd(), 'home': os.environ['CODEX_HOME'],
                  'key': os.environ.get('OPENAI_API_KEY'),
                  'proxy': os.environ.get('https_proxy'), 'args': sys.argv[1:]}))
''')
        self.binary.chmod(0o700)
        self.env = {**os.environ, 'HOME': str(self.base), 'GIT_CONFIG_NOSYSTEM': '1',
                    'GIT_CONFIG_GLOBAL': os.devnull, 'OPENAI_API_KEY': 'test-only'}

    def render(self, namespace='dev', extra=(), success=True):
        out = self.base / ('candidate-' + namespace)
        cmd = ['python3', str(RENDERER), '--output-dir', str(out),
               '--profile', 'gpu1', '--namespace', namespace,
               '--personal-root', str(self.root), '--codex-home', str(self.state),
               '--codex-bin', str(self.binary), '--host-alias', 'gpu',
               '--hostname', 'example.invalid', '--user', 'shared-user',
               '--identity-file', str(self.base / '测试 key'),
               '--git-user-name', 'wjs Example', '--git-user-email', 'wjs@example.invalid',
               '--proxy-url', 'http://127.0.0.1:7890', '--enable-codex-app',
               '--enable-reverse-proxy', '--tunnel-ssh-alias', 'gpu',
               '--remote-proxy-port', '7890', '--laptop-proxy-port', '7891', *extra]
        result = subprocess.run(cmd, capture_output=True, text=True)
        if success:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0)
        return out

    def run_script(self, script, *args, success=True, env=None):
        result = subprocess.run(['bash', str(script), *map(str, args)], cwd=self.root,
                                env=env or self.env, capture_output=True, text=True)
        self.assertEqual(result.returncode == 0, success, result.stderr + result.stdout)
        return result

    def test_namespaces_and_workspaces(self):
        for namespace in ('dev', 'wjs'):
            with self.subTest(namespace=namespace):
                out = self.render(namespace)
                for candidate in out.iterdir():
                    if candidate.read_text().startswith('#!/usr/bin/env bash') or candidate.name.startswith('.bashrc'):
                        subprocess.run(['bash', '-n', str(candidate)], check=True)
                shutil.copy2(out / 'start_codex.sh', self.root / 'start_codex.sh')
                result = self.run_script(out / f'bin-codex-{namespace}', 'exec', 'true')
                actual = json.loads(result.stdout)
                self.assertEqual(Path(actual['cwd']), self.root.resolve())
                self.assertEqual(actual['home'], str(self.state))
                self.assertIsNone(actual['key'])
                self.assertEqual(actual['proxy'], 'http://127.0.0.1:7890')
                self.assertEqual(actual['args'], ['exec', 'true'])
                self.run_script(out / 'start_codex.sh', '-C', self.base, 'exec', 'true', success=False)
                escape = self.root / 'outside'
                if not escape.exists():
                    escape.symlink_to(self.base, target_is_directory=True)
                self.run_script(out / 'start_codex.sh', '--cd=' + str(escape), 'exec', 'true', success=False)
                self.run_script(out / 'start_codex.sh', 'exec', 'true', success=False,
                                env={**self.env, namespace.upper() + '_CODEX_PROFILE': 'wrong'})
                self.run_script(out / 'ssh-codex-dispatch.sh', 'wrong', success=False)
                self.assertTrue((out / f'gpu1-{namespace}-proxy.service').is_file())
                extras = out / f'.bashrc-{namespace}-extras.sh'
                probe = subprocess.run(['bash', '-c', 'source "$1"; ' + namespace + '_proxy_on >/dev/null; printf "%s" "$https_proxy"', 'test', str(extras)], env=self.env, capture_output=True, text=True, check=True)
                self.assertEqual(probe.stdout, 'http://127.0.0.1:7890')
                # OpenSSH parses the generated configuration without a connection.
                subprocess.run(['ssh', '-G', '-F', str(out / 'ssh-config-block.txt'), f'gpu_{namespace}'], stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, check=True)

    def test_git_identity_is_local_and_not_rewritten(self):
        out = self.render()
        subprocess.run(['git', 'init', '-q', str(self.root)], env=self.env, check=True)
        self.run_script(out / 'setup_git_local.sh')
        for key, expected in [('user.name', 'wjs Example'), ('user.email', 'wjs@example.invalid')]:
            result = subprocess.run(['git', 'config', '--local', '--get', key], cwd=self.root, env=self.env, text=True, capture_output=True, check=True)
            self.assertEqual(result.stdout.strip(), expected)
        nonrepo = subprocess.run(['bash', str(out / 'setup_git_local.sh')], cwd=self.base, env=self.env, capture_output=True)
        self.assertNotEqual(nonrepo.returncode, 0)

    def test_wrong_host_and_symlinked_state_rejected(self):
        out = self.render(extra=['--remote-hostname', 'definitely-not-this-host.invalid'])
        self.run_script(out / 'start_codex.sh', 'exec', 'true', success=False)
        out = self.render()
        self.state.rmdir()
        self.state.symlink_to(self.base, target_is_directory=True)
        self.run_script(out / 'start_codex.sh', 'exec', 'true', success=False)

    def test_invalid_namespace_and_proxy_credentials_rejected(self):
        self.render('bad-name', success=False)
        self.render(extra=['--proxy-url', 'http://user:secret@localhost:7890'], success=False)


if __name__ == '__main__':
    unittest.main()
