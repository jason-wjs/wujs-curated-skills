---
name: implement
description: "Use when the user asks to implement an agreed spec or tickets."
disable-model-invocation: true
---

# Implement

Read the spec or tickets and relevant repository context. Complete the agreed
behavior and acceptance criteria, including running or inspecting the result
when that is part of the task. Continue through failures caused by your change.

Use `tdd` when test-first work is requested or already agreed. Choose relevant
checks based on the change; do not add speculative defensive behavior to satisfy
invented test cases. Review the final diff against the requirements and real
failure scenarios; a separate `code-review` invocation is optional.

Report what changed, what was verified, and unresolved limitations. Commit or
publish only within the user's authorization. Do not stop merely because the
first implementation is ready if required work remains.
