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
	if getMatrizSistemaLineal().determinant == 0
		puts "El sistema no se estabiliza"
		return
	end

	estable = false;
	while !estable do
		pasos+=1
		matTemp = $matriz**pasos
		for i in 0...$dim
			for j in 1...$dim
				if (matTemp[0,j] - matTemp[i,j]).abs <= 0.0001
					estable = true
					break
				end
			end
		end
	end

	vector = Matrix.build(1,$dim){-1}
	for i in 0...$dim
		puts "Ingrese el elemento No. #{i} del vector."
		vector.send(:[]=,0,i,(gets.chomp).to_f)
	end	
	printMatrix(vector*matTemp)
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
	# si tiene solución
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
while(op != 0)
	puts "Elige una opción:
			1. Introducir una matriz de un paso de una de Markov (de n X n). 
			2. Obtener las n probabilidades de estado estable.
			3. Obtener la matriz de probabilidades de n pasos. 
			4. Dado un vector de probabilidades iniciales, encontrar las probabilidades de cada estado después de n pasos.
			5. Dado un vector de estado inicial encontrar el estado promedio después de n pasos. 
			6. Dado un vector de estado inicial encontrar el estado promedio cuando el sistema se hace estable. 
			0. Salir."												

	op = (gets.chomp).to_i
	case op
		when 0
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
			printMatrix($matriz)
		when 2
			puts "Probabilidades de Estado Estable:"
			probabilidadesEstadoEstable
		when 3
			puts "Ingrese el número de pasos:"
			pasos = (gets.chomp).to_i
			puts "Matriz de probabilidades de #{pasos} pasos."
			printMatrix($matriz**pasos)
		when 4,5
			vector = Matrix.build(1,$dim){-1}
			for i in 0...$dim
				puts "Ingrese el elemento No. #{i} del vector."
				vector.send(:[]=,0,i,(gets.chomp).to_f)
			end
			puts "Ingrese el numero de pasos:"
			pasos = (gets.chomp).to_i
			if op == 3
				puts "Probabilidades de cada estado después de #{pasos} pasos"
			else
				puts "Estado promedio después de #{pasos} pasos"
			end
			printMatrix(vector*($matriz**pasos))
		when 6
			puts "Estado promedio cuando el sistema se hace estable:"
			estadoPromedio
		else
			puts "Opción no valida."
	end 


end
