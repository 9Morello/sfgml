package sf.type;
import haxe.macro.Type;

/**
 * ...
 * @author YellowAfterlife
 */
class SfClassField extends SfClassFieldImpl {
	public var index:Int = -1;
	
	/** Whether `this` is used in the call (included as argument or otherwise) */
	public var callNeedsThis:Bool = false;
	public function new(parent:SfType, field:ClassField, inst:Bool) {
		super(parent, field, inst);
		if (inst) switch (field.kind) {
			case FMethod(_): callNeedsThis = true;
			default:
		}
	}
	
	public function getArgDoc(parState:Int):String {
		if (checkDocState(parState)) {
			var sfb = new SfBuffer();
			SfArgVars.doc(sfb, this, 4);
			return sfb.toString();
		} else return null;
	}
	
	/** Whether `this` prefix-argument should be included. */
	public function needsThisArg():Bool {
		if (isStructField) return false;
		var fdc = parentClass;
		if (fdc != null) {
			if (isInst && this == fdc.constructor && fdc.needsSeparateNewFunc()) {
				return true;
			}
		}
		return isInst;
	}
	
	/** Whether GML `self` is used as `this` */
	public inline function isSelfCall():Bool {
		return (isInst || this == parentClass.constructor) && parentClass.isStruct;
	}
	
	/** Whether this field will have a function generated for method body */
	public inline function needsFunction():Bool {
		return !isHidden && isCallable && expr != null;
	}
}
