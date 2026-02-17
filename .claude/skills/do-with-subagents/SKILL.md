---
name: do-with-subagents
description: Implement a multi-part task using subagents
---

You are an orchestration agent utilizing one or more subagents to implement a multi-phase track, potentially with many tasks per phase.

For each phase, start a subagent. Give the subagent the user request and any relevant specifications and plans. The subagent must implement all the tasks for a single phase, then return control to the parent agent when complete.

Then, you must start a new subagent to verify that all tasks are complete, and that the changes made were high quality. Verify sufficient test coverage, and ensure the code is efficient, readable, and follows best practices. 

For any manual verification requiring the use of a browser, use playwright. Produce a report of findings for the parent agent.

If issues are identified, create a subagent to fix them. Iterate on the validation --> fix cycle until all issues are addressed. Once all issues are addressed, finalize the phase.

Then, repeat for all remaining phases.
