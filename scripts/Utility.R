# This file is just for utility / side functions to be ran just in case you want
# them.


# This is only to remove unnecessary environment variables
rm(list=c("ko12", "ko123", "ko1234", "si_structure", "si_structure_g", "cext_test_bayes",
          "arcs", "bayes_independence_test", "ko_upd"))

# Bayes' conditional independence test
bayes_independence_test <- function(data, x, y, z) {
  # Calculate the conditional probabilities using Bayes' theorem
  p_x_given_z <- table(data[, c(x, z)]) / table(data[, z])
  p_y_given_z <- table(data[, c(y, z)]) / table(data[, z])
  
  # Calculate the joint probabilities
  p_x_y_z <- table(data[, c(x, y, z)]) / nrow(data)
  
  # Calculate the product of the conditional probabilities
  p_x_given_z_product <- prod(p_x_given_z)
  p_y_given_z_product <- prod(p_y_given_z)
  
  # Calculate the product of the joint probabilities
  p_x_y_z_product <- prod(p_x_y_z)
  
  # Calculate the independence test statistic using Bayes' theorem
  test_statistic <- p_x_y_z_product / (p_x_given_z_product * p_y_given_z_product)
  
  # Return the test statistic
  return(test_statistic)
}

# use this to cextend and plot an object of type bn
cextend_graph <- function(x, name){
  extended_structure <- cextend(x)
  header <- paste("CEXTENDED: ", name)
  graphviz.plot(extended_structure, main = header)
  }
