from typing import Callable


def add_handler(handler: Callable[[int, float], str]):
    pass


def my_handler(arg1: int, arg2: float) -> str:
    pass


def my_broken_handler(arg1: str, arg2: str) -> str:
    pass


add_handler(my_handler)

# error: Argument 1 to "add_handler" has incompatible type "Callable[[str, str], str]";
# expected "Callable[[int, float], str]"
add_handler(my_broken_handler)
