// I'm writing this in functional style to serve as a basis for the compile-time version
type State = {
	instructions: string;
	memoryTape: number[];
	instructionPointer: number;
	memoryTapePointer: number;
	stdout: string;
	matching: number;
};
const brainfudge = (state: State): State => {
	const {
		instructions,
		memoryTape,
		instructionPointer,
		memoryTapePointer,
		stdout,
		matching,
	} = state;

	if (instructionPointer === instructions.length) {
		return state;
	}

	const instruction = instructions[instructionPointer];
	if (matching !== 0) {
		const newMatching =
			instruction === "["
				? matching + 1
				: (instruction === "]"
					? matching - 1
					: matching);
		return brainfudge(
			newMatching === 0
				? {
						...state,
						instructionPointer: instructionPointer + 1,
						matching: newMatching,
					}
				: {
						...state,
						instructionPointer: instructionPointer + (newMatching > 0 ? 1 : -1),
						matching: newMatching,
					}
		);
	}

	const interpret = (): State => {
		switch (instructions[instructionPointer]) {
			case ">":
				return {
					...state,
					memoryTapePointer: memoryTapePointer + 1,
					memoryTape:
						memoryTapePointer + 1 >= memoryTape.length
							? [...memoryTape, 0]
							: memoryTape,
					instructionPointer: instructionPointer + 1,
				};
			case "<":
				return {
					...state,
					memoryTapePointer: memoryTapePointer - 1,
					instructionPointer: instructionPointer + 1,
				};
			case "+": {
				const newMemoryTape = [...memoryTape];
				newMemoryTape[memoryTapePointer] += 1;
				return {
					...state,
					memoryTape: newMemoryTape,
					instructionPointer: instructionPointer + 1,
				};
			}
			case "-": {
				const newMemoryTape = [...memoryTape];
				newMemoryTape[memoryTapePointer] -= 1;
				return {
					...state,
					memoryTape: newMemoryTape,
					instructionPointer: instructionPointer + 1,
				};
			}
			case ".": {
				return {
					...state,
					stdout: stdout + String.fromCharCode(memoryTape[memoryTapePointer]),
					instructionPointer: instructionPointer + 1,
				};
			}
			case ",": {
				throw new Error(
					`Symbol not implemented: ${instructions[instructionPointer]}`
				);
			}
			case "[":
				return memoryTape[memoryTapePointer] === 0
					? {
							...state,
							instructionPointer: instructionPointer + 1,
							matching: 1,
						}
					: { ...state, instructionPointer: instructionPointer + 1 };
			case "]":
				return memoryTape[memoryTapePointer] !== 0
					? {
							...state,
							instructionPointer: instructionPointer - 1,
							matching: -1,
						}
					: { ...state, instructionPointer: instructionPointer + 1 };
			default:
				throw new Error(
					`Symbol not implemented: ${instructions[instructionPointer]}`
				);
		}
	};

	return brainfudge(interpret());
};

const inputState = {
	instructions:
		"++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.",
	memoryTape: [0],
	instructionPointer: 0,
	memoryTapePointer: 0,
  stdout: "",
  matching: 0
} satisfies State;

const result = brainfudge(inputState);

console.log(JSON.stringify(result));
