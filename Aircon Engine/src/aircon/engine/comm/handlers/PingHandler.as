package aircon.engine.comm.handlers
{
	CONFIG::STUDIO
	{
		import aircon.engine.comm.IChannel;
		import aircon.engine.comm.IMessageHandler;
		import aircon.engine.comm.Message;
		import aircon.engine.comm.MessageTypes;

		/** 处理 Studio 发来的 ping，回传 pong 以验证双向通信。 */
		public final class PingHandler implements IMessageHandler
		{
			public function get messageType():String { return MessageTypes.Ping; }

			public function handle(message:Message, channel:IChannel):void
			{
				channel.send(new Message(MessageTypes.Pong));
			}
		}
	}
}
