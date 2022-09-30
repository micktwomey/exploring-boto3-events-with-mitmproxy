from typing import Callable


def add_handler(handler: Callable[[int, float], str]):
    print(handler(1, 4.3))


def my_handler(arg1: int, arg2: float) -> str:
    return str(arg1 + arg2)


def my_broken_handler(arg1: str, arg2: str) -> str:
    return arg1.join(arg2)


add_handler(my_handler)

# error: Argument 1 to "add_handler" has incompatible type "Callable[[str, str], str]";
# expected "Callable[[int, float], str]"
try:
    add_handler(my_broken_handler)
except Exception as e:
    print(e)
