package checkstyle.checks;

import haxe.macro.Expr;
import checkstyle.LintMessage.SeverityLevel;

@name("AvoidStarImport")
@desc("Checks for .* import and using directives")
class AvoidStarImportCheck extends Check {

	public var allowStarImports:Bool;

	public function new() {
		super();
		allowStarImports = false;
	}

	override function actualRun() {
		if (allowStarImports) return;
		var root:TokenTree = checker.getTokenTree();

		checkImports(root.filter([Kwd(KwdImport)], ALL));
	}

	function checkImports(importEntries:Array<TokenTree>) {
		if (allowStarImports) return;

		for (entry in importEntries) {
			var stars:Array<TokenTree> = entry.filter([Binop(OpMult)], ALL);
			if (stars.length <= 0) continue;
			logPos("Import line uses a star (.*) import - consider using full type names", entry.pos, Reflect.field(SeverityLevel, severity));
		}
	}
}