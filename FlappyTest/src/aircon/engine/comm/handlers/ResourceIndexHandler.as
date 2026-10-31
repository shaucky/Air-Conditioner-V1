package aircon.engine.comm.handlers
{
	CONFIG::STUDIO
	{
		import aircon.engine.comm.IChannel;
		import aircon.engine.comm.IMessageHandler;
		import aircon.engine.comm.Message;
		import aircon.engine.comm.MessageTypes;
		import aircon.engine.render.ResourceManager;

		/**
		 * 资源索引处理器：接收 Studio 推送的 GUID → 路径映射，
		 * 注册到 ResourceManager，供 SpriteRenderer 等组件按 GUID 解析资源。
		 *
		 * 条目分两类：
		 *   - 普通资源：GUID 指向文件本身（纹理 / 音频 / 场景…）
		 *   - 精灵子资源：GUID 指向 .acsheet 内的一个精灵，path 为承载它的表文件，
		 *     sprite 字段为该精灵名。组件按精灵引用时走此类。
		 *
		 * 消息格式（payload）：
		 *   { entries: [ { guid: "...", path: "...", sprite?: "..." }, ... ] }
		 */
		public final class ResourceIndexHandler implements IMessageHandler
		{
			public function get messageType():String
			{
				return MessageTypes.ResourceIndex;
			}

			public function handle(message:Message, channel:IChannel):void
			{
				var rm:ResourceManager = ResourceManager.current;
				if (rm == null) return;

				var payload:Object = message.payload;
				if (payload == null) return;

				var entries:Array = payload.entries as Array;
				if (entries == null) return;

				for each (var entry:Object in entries)
				{
					if (entry == null) continue;
					var guid:String = entry.guid as String;
					var path:String = entry.path as String;
					var spriteName:String = (entry.sprite != null) ? String(entry.sprite) : null;
					if (guid != null && path != null)
						rm.registerGuid(guid, path, spriteName);
				}
			}
		}
	}
}
