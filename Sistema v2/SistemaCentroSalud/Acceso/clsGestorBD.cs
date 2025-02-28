﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using Comun;

namespace Acceso
{
    /// <summary>
    /// Clase encargada de conectarse con la base de datos y ejecutar los stored procedures
    /// </summary>
    public class clsGestorBD
    {
        private static string strRuta = AppDomain.CurrentDomain.BaseDirectory;
        private static TextReader tr = new StreamReader(strRuta + "\\Acceso.txt");
        private static string strServidor = tr.ReadLine();
        private static string strCatalogo = tr.ReadLine();
        private static string strUsuario = tr.ReadLine();
        private static string strContrasena = tr.ReadLine();

        public clsGestorBD()
        {
            tr.Close();
            tr.Dispose();
        }
        /// <summary>
        /// Conecta con la base de datos
        /// </summary>
        public static SqlConnection conectar()
        {
            SqlConnection sqlConexion = new SqlConnection("Data Source=" + strServidor + "; Initial Catalog=" + strCatalogo + ";Integrated Security=SSPI");
            //SqlConnection sqlConexion = new SqlConnection("Data Source=" + strServidor + "; Initial Catalog=" + strCatalogo + "; user id = " + strUsuario + "; password = " + strContrasena + "; Trusted_Connection = FALSE");

            return sqlConexion;
        }

        /// <summary>
        /// Conecta con master
        /// </summary>
        public static SqlConnection conectarMaster()
        {
            SqlConnection sqlConexion = new SqlConnection("Data Source=" + strServidor + "; Initial Catalog=master;Integrated Security=SSPI");
            //SqlConnection sqlConexion = new SqlConnection("Data Source=" + strServidor + "; Initial Catalog=master; user id = " + strUsuario + "; password = " + strContrasena + "; Trusted_Connection = FALSE");

            return sqlConexion;
        }

        /// <summary>
        /// Ejecuta un stored procedure y devuelve un 'int'
        /// </summary>
        /// <param name="strNombreStoredProcedure"> Nombre del stored procedure </param>
        /// <param name="lstParametrosSQL"> Lista de parámetros del stored procedure </param>
        /// <returns>int</returns>
        public static int ejecutarStoredProcedureInt(string strNombreStoredProcedure, List<SqlParameter> lstParametrosSQL)
        {
            SqlConnection sqlConexion = conectar();

            try
            {
                sqlConexion.Open();

                SqlCommand sqlComando = new SqlCommand(strNombreStoredProcedure, sqlConexion);
                sqlComando.CommandType = CommandType.StoredProcedure;

                for (int i = 0; i < lstParametrosSQL.Count; i++)
                {
                    sqlComando.Parameters.Add(lstParametrosSQL[i]);
                }

                SqlDataAdapter sqlAdaptador = new SqlDataAdapter(sqlComando);
                DataTable dtTabla = new DataTable();
                sqlAdaptador.Fill(dtTabla);

                sqlConexion.Close();

                return (int)(lstParametrosSQL[lstParametrosSQL.Count - 1].Value);
            }
            catch (Exception ex)
            {
                clsComun.registrarErrorLog(ex.ToString());
                return -1;
            }
            finally
            {
                if (sqlConexion != null)
                {
                    sqlConexion.Close();
                }
            }
        }

        /// <summary>
        /// Ejecuta un stored procedure y devuelve un 'DataTable'
        /// </summary>
        /// <param name="strNombreStoredProcedure"> Nombre del stored procedure </param>
        /// <param name="lstParametrosSQL"> Lista de parámetros del stored procedure </param>
        /// <returns>DataTable</returns>
        public static DataTable ejecutarStoredProcedureDataTable(string strNombreStoredProcedure, List<SqlParameter> lstParametrosSQL)
        {
            SqlConnection sqlConexion = conectar();

            try
            {
                sqlConexion.Open();

                SqlCommand sqlComando = new SqlCommand(strNombreStoredProcedure, sqlConexion);
                sqlComando.CommandType = CommandType.StoredProcedure;

                for (int i = 0; i < lstParametrosSQL.Count; i++)
                {
                    sqlComando.Parameters.Add(lstParametrosSQL[i]);
                }

                SqlDataAdapter sqlAdaptador = new SqlDataAdapter(sqlComando);
                DataTable dtTabla = new DataTable();
                sqlAdaptador.Fill(dtTabla);
                
                sqlConexion.Close();

                return dtTabla;
            }
            catch(Exception ex)
            {
                clsComun.registrarErrorLog(ex.ToString());
                return null;
            }
            finally
            {
                if (sqlConexion != null)
                {
                    sqlConexion.Close();
                }
            }
        }

        /// <summary>
        /// Ejecuta un stored procedure y devuelve un 'DataSet'
        /// </summary>
        /// <param name="strNombreStoredProcedure"> Nombre del stored procedure </param>
        /// <param name="lstParametrosSQL"> Lista de parámetros del stored procedure </param>
        /// <returns>DataSet</returns>
        public static DataSet ejecutarStoredProcedureDataSet(string strNombreStoredProcedure, List<SqlParameter> lstParametrosSQL)
        {
            SqlConnection sqlConexion = conectar();

            try
            {
                sqlConexion.Open();

                SqlCommand sqlComando = new SqlCommand(strNombreStoredProcedure, sqlConexion);
                sqlComando.CommandType = CommandType.StoredProcedure;

                for (int i = 0; i < lstParametrosSQL.Count; i++)
                {
                    sqlComando.Parameters.Add(lstParametrosSQL[i]);
                }

                SqlDataAdapter sqlAdaptador = new SqlDataAdapter(sqlComando);
                DataSet dsTabla = new DataSet();
                sqlAdaptador.Fill(dsTabla);

                sqlConexion.Close();

                return dsTabla;
            }
            catch (Exception ex)
            {
                clsComun.registrarErrorLog(ex.ToString());
                return null;
            }
            finally
            {
                if (sqlConexion != null)
                {
                    sqlConexion.Close();
                }
            }
        }

        /// <summary>
        /// Ejecuta una sentencia SQL y devuelve un 'bool'
        /// </summary>
        /// <param name="sqlConexion"> Conexión </param>
        /// <param name="strSentenciaSQL"> Sentencia SQL </param>
        /// <returns>bool</returns>
        public static bool ejecutarSentenciaSQL(SqlConnection sqlConexion, string strSentenciaSQL)
        {
            try
            {
                sqlConexion = conectar();
                SqlCommand sqlComando = new SqlCommand(strSentenciaSQL, sqlConexion);
                sqlConexion.Open();

                sqlComando.ExecuteNonQuery();
                sqlConexion.Close();

                return true;
            }
            catch (Exception ex)
            {
                clsComun.registrarErrorLog(ex.ToString());
                return false;
            }
        }
    }
}
