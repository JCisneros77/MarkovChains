require 'matrix'

# Funcion para imprimir la matriz
def printMatrix(m)
	for i in 0...m.row_count
		print "|"
		for j in 0...m.column_count
			print "#{m[i,j]}  |"
		end
		puts
	end
end


def estadoPromedio
	pasos = 0
	# Si el determinante es 0 entonces el sistema
	# no se estabiliza.
	if getMatrizSistemaLineal().determinant == 0
		puts "El sistema no se estabiliza"
		return
	end

	# Realizar operaciones hasta que el sistema
	# se estabilize. 
	estable = false;
	while !estable do
		# Llevar el contador de cuantos pasos
		# tomó para que el sistema se estabilizara
		pasos+=1
		# Sacar la matriz de n pasos
		matTemp = $matriz**pasos
		# Checar si todas las filas son iguales a
		# la primera fila con un margen de error
		# de .000001.
		iguales = true
		for i in 0...$dim
			for j in 1...$dim
				if (matTemp[0,j] - matTemp[i,j]).abs >= 0.000001
					# Si una no es igual, el sistema no se ha
					# estabilizado, se sigue a la proxima iteración
					iguales = false
					break
				end
			end
			if !iguales
				break
			end
		end
		# Si las filas son iguales, el sistema ya
		#se estabilizó. 
		if iguales
			break
		end
	end
	# Pedir el vector al usuario
	vector = Matrix.build(1,$dim){-1}
	for i in 0...$dim
		puts "Ingrese el elemento No. #{i} del vector."
		vector.send(:[]=,0,i,(gets.chomp).to_f)
	end	
	# Multiplicar el vector por la matriz de
	# estado estable
	printMatrix(vector*($matriz**pasos))
end

def probabilidadesEstadoEstable
	# Sacar la matriz con el sistema lineal
	a = getMatrizSistemaLineal
	# Inicializar la matriz de resultado
		# Los resultados de las ecuaciones son 0
		# Excepto por la primera que es la matriz
		# que se agrego cuyo resultado es 1
	b = Matrix.build($dim,1){0.0}
	b.send(:[]=,0,0,1.0)
	# Se calcula la determinante de a para saber
	# si tiene solución, si es 0 el sistema
	# no se estabiliza
	if a.determinant == 0
		puts "El sistema no se estabiliza"
		return
	end
	# Se resuelve el sistema para obtener las probabilidades
	# de estado estable
		# ax=b => x = a^-1 * b
	probsES = (a.inv) * b
	printMatrix(probsES)

end

def getMatrizSistemaLineal
	# Matriz de ecuaciones
	# Incluyendo la última fila de 1's de la ecuación agregada
	matrizSistemaLineal = Matrix.build($dim){1.0}
	# Formar la matriz de ecuaciones quitando la primer ecuacion
	for i in 1...$dim
		for j in 0...$dim
			matrizSistemaLineal.send(:[]=,i,j,$matriz[j,i])
			if i == j
				# A la diagonal principal se le resta 1
				# para igualar las ecuaciones a 0
				matrizSistemaLineal.send(:[]=,i,j,matrizSistemaLineal[i,j] - 1.0)
			end
		end
	end 
	return matrizSistemaLineal
end

# ----------------- Main -----------------
# Menu 
# TEST
			#$matriz = Matrix[[0.1666,0.3333,0.3333,0.1666],[0.1666,0.1666,0.3333,0.3333],[0.3333,0.1666,0.1666,0.3333],[0.3333,0.3333,0.1666,0.1666]]
			$matriz = Matrix[[0.65,0.2,0.15],[0.6,0.15,0.25],[0.5,0.1,0.4]]
			printMatrix($matriz)
			$dim = 3
op = -1
# Imprimir Menú
while(op != 0)
	puts "Elige una opción:
			1. Introducir una matriz de un paso de una de Markov (de n X n). 
			2. Obtener las n probabilidades de estado estable.
			3. Obtener la matriz de probabilidades de n pasos. 
			4. Dado un vector de probabilidades iniciales, encontrar las probabilidades de cada estado después de n pasos.
			5. Dado un vector de estado inicial encontrar el estado promedio después de n pasos. 
			6. Dado un vector de estado inicial encontrar el estado promedio cuando el sistema se hace estable. 
			0. Salir."												
	# Obtener opción del usuario
	op = (gets.chomp).to_i
	case op
		when 0 # Salir
			exit
		when 1
			# Inicializar matriz
			puts "Escriba la dimensión de la Matrix (nxn)"
			$dim = (gets.chomp).to_i
			$matriz = Matrix.build($dim){-1}
			# Pedir los elementos de la matriz al usuario
			$matriz.each_with_index do |e, row, col|
				puts "Ingrese el elemento en la posicion (#{row},#{col})"
				$matriz.send(:[]=,row,col,(gets.chomp).to_f)
			end
			# Imprimir matriz ingresada por el usuario
			puts "Esta es la matriz que ingresaste:"
			printMatrix($matriz)
		when 2 # Obtener n probabilidades de estado estable
			puts "Probabilidades de Estado Estable:"
			probabilidadesEstadoEstable
		when 3 # Obtener matriz de probabilidades de n pasos
			puts "Ingrese el número de pasos:"
			pasos = (gets.chomp).to_i # Pedir al usuario el número de pasos
			puts "Matriz de probabilidades de #{pasos} pasos."
			# Se eleva la matriz a la n (pasos) para encontrar la matriz
			# de n pasos
			printMatrix($matriz**pasos)
		when 4,5 # Encontrar probabilidades y estado promedio después de n pasos
			vector = Matrix.build(1,$dim){-1} # Pedir al usuario el vector
			for i in 0...$dim
				puts "Ingrese el elemento No. #{i} del vector."
				vector.send(:[]=,0,i,(gets.chomp).to_f)
			end
			puts "Ingrese el numero de pasos:" # Pedir al usuario el número de pasos
			pasos = (gets.chomp).to_i
			if op == 4
				puts "Probabilidades de cada estado después de #{pasos} pasos"
			else
				puts "Estado promedio después de #{pasos} pasos"
			end
			# Se multiplica el vector por la matriz de n pasos
			printMatrix(vector*($matriz**pasos))
		when 6 # Estado promedio cuando el sistema es estable
			puts "Estado promedio cuando el sistema se hace estable:"
			estadoPromedio
		else
			puts "Opción no valida."
	end 


end
