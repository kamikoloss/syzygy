class_name Util
extends Node


## ref. https://forum.godotengine.org/t/put-commas-into-a-number-gdscript/116184/3
static func format_number_with_commas(number: int) -> String:
    var num_str: String = str(number).lstrip("-")
    var result: String = ""
    var count: int = 0
    for i in range(num_str.length() - 1, -1, -1):
        result = num_str[i] + result
        count += 1
        if count % 3 == 0 and i != 0:
            result = "," + result
    if number < 0:
        result = "-" + result
    return result
