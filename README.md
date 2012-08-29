# Idea

The controller is the only place of the system that natively knows about the
user (as user identificatoin happens per HTTP request). But permissions should
be decided on model level. If all communication within a controller happens
with Security-proxied objects, everything should be safe. (To be proved.)

# Current drawbacks/questions of this solution

1. [SOLVED] Proxying of class methods - how does it work or is it needed at all?
2. How to secure non-static concerns (e.g. rules that regard ownership, time, …) with this system?
3. Is a separate PermissionStore needed?
4. Naming/API

