export type FrameworkPacket = {
	new: () -> (),
	Init: () -> (),
	Start: () -> (),

	LoadModules: (Container: { Folder: any }) -> (),

	Modules: { [string]: any },
	[string]: any,

	_index: {
		Instance: {
			new: (Object: string, Properties: { [string]: any }) -> (),
		},

		Memory: {
			new: () -> (),
			Set: (Key: string, Value: any) -> (),
			SetTable: (TableName: string, Key: string, Value: any) -> (),
			SetCFrame: (Key: string, Value: CFrame) -> (),
			SetVec3: (Key: string, Value: Vector3) -> (),

			Get: (Key: string) -> any,
			GetCFrame: (Key: string) -> CFrame?,
			GetVec3: (Key: string) -> Vector3?,

			Clear: (Key: string) -> (),
			Remove: (Key: string) -> (),
			Destroy: () -> nil,
		},

		Serialize: {
			CFrame: {
				serialize: (Value: CFrame) -> buffer,
				deserialize: (Buffer: buffer) -> CFrame?,

				serializecf: (CFrame: CFrame) -> buffer,
				deserializecf: (Buffer: buffer) -> CFrame,
				editcf: (Buffer: buffer) -> buffer,
			};
			Vec3: {
				serialize: (Value: Vector3) -> buffer,
				deserialize: (Buffer: buffer) -> Vector3?,
				edit: (Buffer: buffer, Value: Vector3) -> buffer,
			};
			Vec2: {
				serialize: (Value: Vector2) -> buffer,
				deserialize: (Buffer: buffer) -> Vector2?,
				edit: (Buffer: buffer, Value: Vector2) -> buffer,
			};
			Str: {
				serialize: (Value: string) -> buffer,
				deserialize: (Buffer: buffer) -> string?,
			};
		};

		Signal: {
			new: (
			) -> {
				new: () -> any,
				Connect: (self: any, Func: (...any) -> ()) -> RBXScriptConnection,
				Fire: (self: any, ...any) -> (),
				Destroy: (self: any) -> nil,
			};
		};
        Remote: {
            new: (ModuleName: string, Name: string, Type: string | RemoteEvent) -> any,
            Fire: (self: any, ...any) -> ();
            FireClient: (self: any, Player: Player, ...any) -> ();
            FireOther: (self: any, Player: Player, ...any) -> ();
            Connect: (self: any, Func: (Player: Player,...any) -> ()) -> RBXScriptConnection,
            Destroy: (self: any) -> nil,
        };

        TextEditor: {
            Format: (Text: string) -> string,
        };

		Wire: {
			DrawLine: (self: any,from: Vector3, to: Vector3) -> nil;
			DrawPath: (self: any,{Vector3},Loop: boolean) -> nil;
			DrawAxis: (self: any,Position: Vector3) -> nil;
			DrawCircle: (self: any,Position: Vector3,Radius: number,Segments: number) -> nil;
			DrawSphere: (self: any,Position: Vector3,Radius: number,Segments: number,Normal: Vector3) -> nil;
			DrawCone: (self: any,Position: Vector3, Radius: number,Height: number, Segments: number, Normal: Vector3) -> nil;
			DrawText: (self: any,position: Vector3,size: number,any) -> nil;
			DrawBox: (self: any,Position: Vector3, Size: number,LookAt: Vector3 | nil) -> nil;
			
			SetColor: (Color3: Color3 | string) -> nil;
			SetTransparency: (Opacity: number) -> (nil);
			FillBoxAnimation: (Position: Vector3,Size: number,LookAt: Model,Stop:Signal,Success: () -> (boolean)) -> (nil);
		}

	},
}
return nil;