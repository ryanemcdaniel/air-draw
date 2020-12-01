using System;
using System.Threading;
using TobiasErichsen.teVirtualMIDI;

    class Program
    {

		public static string byteArrayToString(byte[] ba)
		{

			string hex = BitConverter.ToString(ba);

			return hex.Replace("-", ":");

		}

		static void Test(string[] args)
		{
			Driver dvr = new Driver();
			string command= Console.ReadLine();
			while(command != "exit")
            {
				if(command == "a")
                {
					dvr.play();

                }
				else if(command == "s")
                {
					dvr.pause();
                }
				else if(command == "d")
                {
					dvr.playNote();
                }


				command = Console.ReadLine();
            }
			dvr.closePort();

		}
	}
