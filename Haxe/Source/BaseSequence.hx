package;

enum SequenceKind {
    Stay;
    Title;
    Game;
}

interface BaseSequence {
    function start():Void;
    function update(): SequenceKind;
}