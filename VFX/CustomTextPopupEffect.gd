@tool
class_name CustomTextPopupEffect
extends RichTextEffect

# To use this effect:
# - Enable BBCode on a RichTextLabel.
# - Register this effect on the label.
# - Use [CustomTextPopupEffect param=2.0]hello[/CustomTextPopupEffect] in text.
var bbcode = "popup"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	return true
