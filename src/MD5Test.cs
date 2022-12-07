using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using STLib.OpenGL;
using STLib.OpenGL.GL;
using STLib.OpenGL.GLFW;

using System.IO;
using System.Security.Cryptography;

namespace STGL
{
    class MD5Test
    {
        public static void Run() {
            // GLFW 项目初始化。。GUI相关
            GLFW.Init();
            GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3);                 // 期望的OpenGL版本为3.3
            GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 3);
            GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE); // 核心模式
            GLFW.WindowHint(GLFW.VISIBLE, GLFW.FALSE);                      // 默认创建的窗口不显示
            if (RuntimeInfo.System == RuntimeInfo.SystemType.Mac) {
                GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL.GL_TRUE);    // For Mac system
            }

            //生成测试字典
            //using (StreamWriter writer = new StreamWriter("./md5_test.txt", false, Encoding.UTF8)) {
            //    for (int i = 0; i < 10000000; i++) {
            //        writer.WriteLine(i);
            //    }
            //}

            MD5 md5 = MD5.Create();
            Console.WriteLine("MD5: 283f42764da6dba2522412916b031080");
            Console.WriteLine("=====================================");
            var sw = new System.Diagnostics.Stopwatch();
            sw.Start();
            // 自带MD5算法 这里仅统计了计算MD5时间 没有比较
            using (StreamReader reader = new StreamReader("./md5_test.txt", Encoding.UTF8)) {
                string strLine = string.Empty;
                while ((strLine = reader.ReadLine()) != null) {
                    byte[] by = Encoding.UTF8.GetBytes(strLine);
                    md5.ComputeHash(by);
                }
            }
            sw.Stop();
            Console.WriteLine("NET_MD5_TIME: " + sw.ElapsedMilliseconds);
            Console.WriteLine("=====================================");
            sw.Reset();
            sw.Start();
            var aa = CPUMd5.Run("./md5_test.txt", "283f42764da6dba2522412916b031080");
            sw.Stop();
            Console.WriteLine("CPU_TIME: " + sw.ElapsedMilliseconds);
            Console.WriteLine("CPU_RESULT: " + aa);
            Console.WriteLine("=====================================");
            sw.Reset();
            sw.Start();
            var bb = OpenGLMd5.Run("./md5_test.txt", "283f42764da6dba2522412916b031080", 4000000);
            sw.Stop();
            Console.WriteLine("GL_TIME: " + sw.ElapsedMilliseconds);
            Console.WriteLine("GL_RESULT: " + bb);
            Console.WriteLine("=====================================");
            sw.Reset();
            sw.Start();
            // gl_md5 为结构化后的文件
            var cc = OpenGLMd5_1.Run("./gl_md5", "283f42764da6dba2522412916b031080", 4000000);
            sw.Stop();
            Console.WriteLine("GL_NEW_TIME: " + sw.ElapsedMilliseconds);
            Console.WriteLine("GL_NEW_RESULT: " + cc);

            GLFW.Terminate();
            Console.ReadKey();
        }
        /// <summary>
        /// 结构化原始字典文件
        /// </summary>
        /// <param name="strDicFile">原始文本文件</param>
        /// <param name="strOutFile">结构化后文件</param>
        public static void CreateDic(string strDicFile, string strOutFile) {
            byte[] by_temp = new byte[16];
            using (FileStream fs_out = new FileStream(strOutFile, FileMode.Create, FileAccess.Write)) {
                using (StreamReader reader = new StreamReader(strDicFile, Encoding.UTF8)) {
                    string strLine = string.Empty;
                    while ((strLine = reader.ReadLine()) != null) {
                        if (strLine == string.Empty) continue;
                        var bytes = Encoding.UTF8.GetBytes(strLine);
                        for (int i = 0; i < bytes.Length && i < 16; i++) {
                            by_temp[i] = bytes[i];
                        }
                        for (int i = 0, nLen = 16 - bytes.Length; i < nLen; i++) {
                            by_temp[i + bytes.Length] = 0;
                        }
                        fs_out.Write(by_temp, 0, by_temp.Length);
                    }
                }
            }
        }
    }
}
