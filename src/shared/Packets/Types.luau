
--// OPEN SOURCE //--
export type Trove = {
	new: () -> Trove;
	Connect: (self: Trove, Signal: any, Func: (...any) -> ()) -> ();
	Add: (self: Trove, Item: any) -> ();
	Clean: (self: Trove) -> ();
	Destroy: (self: Trove) -> ();
}
--// SIGNAL //--
export type Signal = {
	new: () -> Signal;
	Connect: (self: Signal, Callback: () -> ()) -> ();
	Disconnect: (self: Signal) -> ();
	DisconnectOne: (self: Signal, Callback: () -> ()) -> ();
	Fire: (self: Signal, ...any) -> ();
	Once: (self: Signal, Callback: () -> ()) -> ();
}
--// DATA TYPES //--
export type Assert = {
	(Condition: any, Message: string?) -> any
};
export type Cache = {
	new: (Size: number?, Object: BasePart) -> Cache;
	ReturnToPool: (self: Cache, Items: {any}) -> ();
	GetPool: (self: Cache, N: number) -> {any} | nil;
}
export type Memory = {
	new: () -> Memory;

	Cache: {[any]: any};
	Set: (self: Memory, Key: any, Value: any) -> ();
	Insert: (self: Memory, Value: any) -> ();

	SetTable: (self: Memory, TableName: string, Key: any, Value: any) -> nil;
	SetCFrame: (self: Memory, Key: any, Value: CFrame) -> nil;
	SetVec3: (self: Memory, Key: any, Value: Vector3) -> nil;

	Get: (self: Memory, Key: any) -> any;
	GetCFrame: (self: Memory, Key: any) -> CFrame | nil;
	GetVec3: (self: Memory, Key: any) -> Vector3 | nil;

	Remove: (self: Memory, Key: any) -> ();
	Clear: (self: Memory) -> ();
	Destroy: (self: Memory) -> ();
}
export type Stack ={ 
	new: () -> Stack;
	Push: (self: Stack, value: any) -> ();
	Pop: (self: Stack) -> any;
	Peek: (self: Stack) -> any;
	IsEmpty: (self: Stack) -> boolean;
}
--// INPUT TYPES //--
export type _Keyboard = {
	new: () -> _Keyboard;
	_trove: Trove;
	KeyDown: Signal;
	KeyUp: Signal;
	IsKeyDown: (self: _Keyboard, KeyCode: Enum.KeyCode) -> boolean;
	Destroy: (self: _Keyboard) -> ();
}
export type _Mouse = {
	new: () -> _Mouse;
	_trove: Trove;
	Mouse: any;
	LeftDown: Signal;
	RightDown: Signal;
	LeftUp: Signal;
	RightUp: Signal;
	IsLeftDown: () -> boolean;
	IsRightDown: () -> boolean;
}
export type _Mobile = {
	new: () -> _Mobile;
	FingerUp: Signal;
	FingerDown: Signal;
	TouchMoved: Signal;
	LastPosition: Vector2;
	ActiveTouches: {[any]: Vector2};

	GetFingerPosition: (self: _Mobile, input: any) -> Vector2;
	GetClosestFinger: (self: _Mobile, position: Vector2) -> any;

	IsMobileDevice: () -> boolean;
	GetActiveFingers: (self: _Mobile) -> {[any]: Vector2};
	IsTouchDown: (self: _Mobile) -> boolean;
}
export type _Gamepad = {
	new: () -> _Gamepad;
	_trove: Trove;

	GAMEPAD: Enum.UserInputType;
	ButtonUp: Signal;
	ButtonDown: Signal;
	IsButtonDown: (Keycode: Enum.KeyCode, Gamepad: Enum.UserInputType) -> boolean;
	IsMotorSupported: (self: _Gamepad) -> boolean;
	PulseMotor: (self: _Gamepad, Motor: Enum.VibrationMotor, Time: number, Intensity: number) -> ();
	StopMotor: (self: _Gamepad, Motor: Enum.VibrationMotor?) -> ();

	IsConsole: (self: _Gamepad) -> boolean;
	GetUserInputType: (self: _Gamepad) -> Enum.UserInputType;
	IsGamepadConnected: () -> boolean;
	Destroy: (self: _Gamepad) -> ();
}
export type Input = {
	Keyboard: _Keyboard;
	Mouse: _Mouse;
	Mobile: _Mobile;
	Gamepad: _Gamepad;
}
--// INSTANCE TYPES //--
export type Instance = {
	new: (ClassName: string, Properties: {[any]: any}) -> any;
};
--// MAID TYPES //--
export type Maid = {
	new: () -> Maid;
	Connect: (self: Maid, C: RBXScriptConnection, Fnc: (any) -> ()) -> (any);
	AddTask: (self: Maid, Fnc: () -> ()) -> ();
	Cleanup: (self: Maid) -> ();
	Destroy: (self: Maid) -> ();
}
--// SERIALIZE //--
export type BufferNumber = {
	new: () -> BufferNumber;
	serialize: (self: BufferNumber,Data: Vector3 | Vector2 | CFrame) -> buffer;
	deserialize: (self: BufferNumber,b: buffer) -> Vector3 | Vector2 | CFrame;
	edit: (self: BufferNumber,b: buffer, k: Vector3 | Vector2 | CFrame) -> buffer;
}
export type BufferString = {
	new: () -> BufferString;
	serialize: (self: BufferString,Data: string) -> buffer;
	deserialize: (self: BufferString,b: buffer, String_Len: number) -> string;
	edit: (self: BufferString,b: buffer, k: string) -> buffer;
}
export type Serialize = {
	CFrame: BufferNumber;
	Vec3: BufferNumber;
	Vec2: BufferNumber;
	String: BufferString;
}
--// SIGNAL //--
export type Remote = {
	_trove: Trove;
	_signal: Signal;
	_name: string;
	_type: string | RemoteEvent;
	_event: RemoteEvent | UnreliableRemoteEvent;
	
	new: (MobuleName: string, Name: string, Type: string | RemoteEvent) -> Remote;
	GetRemotes: () -> {Instance};

	Fire: (self: Remote, Player: Player, ...any) -> ();
	FireAll: (self: Remote, ...any) -> ();
	FireOther: (self: Remote, Player: Player, ...any) -> ();
	FireClient: (self: Remote, Player: Player, ...any) -> ();
	Connect: (self: Remote, Fnc: (...any) -> (any)) -> ();

	GetRemoteFolder: () -> Folder;
	Destroy: (self: Remote) -> ();
}
--// STRING //--
export type TextEditor = {
	Format: (str: string) -> string;
	GetNumber: (value: number) -> string;
}
--// TWEEN //--
export type Tween = {
	ModelCF: (self: Tween, Object: Model, TweenInfo: TweenInfo, EndPosition: CFrame | Vector3, Defer: boolean) -> ();
}
--// UI //--
export type UI_ENUM = {
    Activated: string;
    Enter: string;
    Leave: string;
}
export type UI = {

	Enum: UI_ENUM;
	_Maid: Maid;
    _Mem: Memory;
    _Stack: Stack;
    _Signal: Signal;
    _Parent: Instance;
}
--// WIREFRAME //--
export type Wireframe = {
	SetColor: (self: Wireframe, Color3: Color3 | string) -> ();
	SetTransparency: (self: Wireframe, n: number) -> ();
	DrawLine: (self: Wireframe, from: Vector3, to: Vector3) -> ();
	DrawPath: (self: Wireframe, points: {Vector3}, loop: boolean) -> ();
	DrawText: (self: Wireframe, position: Vector3, size: number,string) -> ();
	DrawBox: (self: Wireframe, position: Vector3, size: number, lookAt: Vector3 | nil) -> ();
	DrawSphere: (self: Wireframe, position: Vector3, radius: number, lookAt: Vector3 | nil) -> ();
	FillBoxAnimation: (self: Wireframe, position: Vector3, Size: number, lookAt: Model | BasePart, Cancel: Signal | nil, Result: (Model: Model) -> ()) -> ();
	DrawCircle: (self: Wireframe, position: Vector3, radius: number, segments: number, normal: Vector3) -> ();
	DrawAxis: (self: Wireframe, position: Vector3, size: number) -> ();
	DrawCone: (self: Wireframe, position: Vector3, radius: number, height: number, segments: number, normal: Vector3 | nil) -> ();
	DrawRay: (self: Wireframe, origin: Vector3, direction: Vector3, Raycast: RaycastResult) -> ();
}
--// WORLD //--
export type Water = {
	CalculateHeight: (self: Water, X: number, Z: number) -> number;
}
--// FRAMEWORK // --

export type index = {
	--// Data //
	Cache: Cache;
	Memory: Memory;
	Stack: Stack;
	Assert: Assert;
	--// Input //
	Input: Input;
	--// Instance //
	Instance: Instance;
	--// Maid //
	Maid: Maid;
	--// Serialize //
	Serialize: Serialize;
	--// Signal //
	Signal: Signal;
	Remote: Remote;
	--// String //
	TextEditor: TextEditor;
	--// Tween //
	Tween: Tween;
	--// UI //
	UI: UI;
	--// Wireframe //
	Wireframe: Wireframe;
	--// World //
	Water: Water;
}

export type FrameworkIndex = {
	Framework: Framework;
	_index: index;
	
}

export type Framework = {
	new: () -> any;
	Init: (self: Framework) -> ();
	Start: (self: Framework) -> ();
	
	LoadModules: (self: Framework, Container: {[Folder]: Instance} | ModuleScript) -> any;
	
	_loaded: boolean;
	_started: boolean;
}

return nil