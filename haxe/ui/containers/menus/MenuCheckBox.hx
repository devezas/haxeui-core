package haxe.ui.containers.menus;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.components.CheckBox;
import haxe.ui.components.Label;
import haxe.ui.core.Component;
import haxe.ui.core.CompositeBuilder;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.util.Variant;

@:composite(Builder)
class MenuCheckBox extends MenuItem {
    @:clonable @:behaviour(TextBehaviour)           public var text:String;
    @:clonable @:behaviour(ShortcutTextBehaviour)   public var shortcutText:String;
    @:clonable @:behaviour(SelectedBehaviour)       public var selected:Bool;
}

//***********************************************************************************************************
// Behaviours
//***********************************************************************************************************
@:dox(hide) @:noCompletion
private class TextBehaviour extends DataBehaviour {
    private override function validateData() {
        var checkbox:CheckBox = _component.findComponent(CheckBox, false);
        if (checkbox == null) {
            checkbox = new CheckBox();
            checkbox.styleNames = "menuitem-checkbox";
            _component.addComponent(checkbox);
        }

        checkbox.text = _value;
    }
}

@:dox(hide) @:noCompletion
private class ShortcutTextBehaviour extends DataBehaviour {
    private override function validateData() {
        var label:Label = _component.findComponent("menuitem-shortcut-label", false);
        if (label != null) {
            label.text = _value;
        }
    }
}

@:dox(hide) @:noCompletion
private class SelectedBehaviour extends DataBehaviour {
    private override function validateData() {
        var checkbox:CheckBox = _component.findComponent(CheckBox, false);
        if (checkbox == null) {
            checkbox = new CheckBox();
            checkbox.styleNames = "menuitem-checkbox";
            _component.addComponent(checkbox);
        }

        checkbox.selected = _value;
    }

    public override function get():Variant {
        var checkbox:CheckBox = _component.findComponent(CheckBox, false);
        if (checkbox == null) {
            return false;
        }
        return checkbox.selected;
    }
}

//***********************************************************************************************************
// Composite Builder
//***********************************************************************************************************
@:dox(hide) @:noCompletion
@:access(haxe.ui.core.Component)
private class Builder extends CompositeBuilder {
    private var _checkbox:CheckBox;

    public function new(component:Component) {
        super(component);
        component.registerEvent(MouseEvent.CLICK, onClick);
    }

    public override function create() {
        _checkbox = new CheckBox();
        _checkbox.styleNames = "menuitem-checkbox";
        _checkbox.percentWidth = 100;
        _checkbox.registerEvent(UIEvent.CHANGE, onCheckboxChange);
        _component.addComponent(_checkbox);

        var label = new Label();
        label.id = "menuitem-shortcut-label";
        label.styleNames = "menuitem-shortcut-label";
        _component.addComponent(label);
    }

    private function onCheckboxChange(event:UIEvent) {
        _component.dispatch(event);
    }

    private function onClick(event:MouseEvent) {
        if (_checkbox.hitTest(event.screenX, event.screenY)) {
            return;
        }
        _checkbox.selected = !_checkbox.selected;
    }
}
