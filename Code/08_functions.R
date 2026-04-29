# My functions
porco_dio = function(x,y){
  z = x + y
  return(z)
  }

# make a function that says porca madonna
semplicemente_ciao = function(x,y){
  z = x - y
  return(z)
  }

#cambiare nome a funzioni
mf = function(nx = 1, ny = 2) {
  par(mfrow=c(nx,ny))
  }
#nx = 1 e ny = 2 sono i valori di default
#quindi se so che ho bisogno di fare tante volte questo confronto posso impostare un default e quindi se scrivo solo mf() usa i valori di default
#se non metto =1 e =2 allora non ha valori di default

#if else 
numeri = function(x){
  if(x>0){
    print("Questo numero è positivo")
    } else if (x<0){
    print ("Questo numero è negativo")
    } else if (x == 0){
    print("porco dio")
    }
  }
loop <- function() {
  for (i in 1:5) {
    return(i)
  }
}

loop2 <- function() {
for (i in 1:5) {
  result <- i * 2
  print(result)
  }
}
#ciclo for
plot(seq(-5,5,0.1), dnorm(seq(-5,5,0.1), 0,1), type = "l")
 for(gdl in c(2,5,10,20,30)){
   lines(seq(-5,5,0.1), dt(seq(-5,5,0.1), df=gdl), lty=2)
 }

sink(data.txt")
loop2()
sink()




























