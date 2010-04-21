package org.yellcorp.debug.console
{
import org.yellcorp.math.MathUtil;


public class InputCompleter
{
    private var input:InputEditor;
    private var resolver:CompletionCandidates;
    private var candidates:Array;
    private var currentCandidate:int;
    private var originalInput:String;
    private var dirty:Boolean;

    public function InputCompleter(initInput:InputEditor, initResolver:CompletionCandidates)
    {
        input = initInput;
        resolver = initResolver;
        dirty = true;
    }

    public function edited():void
    {
        dirty = true;
    }

    public function advance(direction:int):void
    {
        if (dirty)
        {
            refreshCandidates();
        }

        if (currentCandidate == candidates.length)
        {
            input.setInput(originalInput);
        }
        currentCandidate = MathUtil.positiveMod(currentCandidate + direction, candidates.length + 1);
    }

    private function refreshCandidates():void
    {
        originalInput = input.getInput();
        candidates = resolver.getCandidates(originalInput) || [ ];
        candidates.sort();
        currentCandidate = 0;
        dirty = false;
    }
}
}
