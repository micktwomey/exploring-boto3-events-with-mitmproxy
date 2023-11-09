event_hooks = []

def event_emitting_call(arg):
   # ... do some work
   for hook in event_hooks:
     hook(("event", arg))

def register(callable):
  event_hooks.append(callable)

register(print)
event_emitting_call("hello")
