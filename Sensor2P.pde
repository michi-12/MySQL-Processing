import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;

import processing.serial.*; //Puerto Serial en Arduino
import de.bezier.data.sql.*;  //Puerto con MySQL

MySQL mysql;

Serial puertoSerie; //Variable para puerto Serial
String val;  //Dato recibidos por el puerto serial de Arduino
float valorDHT  = 0;  //Variable para almacenar el valor recibido
float [] temperatura = {40.0};

void setup() {
  size (530, 300); 
  puertoSerie = new Serial(this, "COM4", 9600); //Comunicación con Arduino
  val = "0";
  String user= "root";
  String password= "";
  String dbHost= "localhost:3307";
  String database= "laboratorio4";
  mysql= new MySQL(this, dbHost, database, user,password);
}

void draw() {
  delay(1000);
  background(#B1FAF6);  //Fondo
  fill(0);
  textSize(23);  //Tamaño de fuente
  float x = width * 0.1;
  float y = height *  0.9;
  float delta = width * 0.8;
  float w = delta * 0.8;
  for (float val : temperatura){
      float h = map(val, 0, 100, 0, height);
      fill(255);
      rect(320, 130, 140, 30);
      x = x + delta;
  }
  
  while(puertoSerie.available()>0){
    String buffer = puertoSerie.readString();
    if(buffer!=null){
      //println(buffer);
      fill(#0B0F0B);
      text("Temperatura: "+buffer +"°C",60,150);
      if(mysql.connect()){
        println("conectado");
        mysql.execute( "INSERT INTO temperatura(temperaturacel, tiempo) VALUES("+buffer+", NOW());" );
       
      }
    }
    }
  }
