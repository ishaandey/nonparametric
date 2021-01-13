permutation_test <- function(sample1, sample2, method='mean', alternative='two.sided') {
  m <- length(sample1)
  n <- length(sample2)
  sample_pooled <- c(sample1, sample2)
  
  perm_ct <- choose(m+n,m)
  perm1 <- t(combn(sample_pooled,m))
  
  perm2 <- NULL
  for (i in 1:perm_ct){
    perm2 <- rbind(perm2, setdiff(sample_pooled, perm1[i,]))
  }
  
  diff.perm <- rep(NA, choose(m+n,m))
  
  if (method == 'mean') {
    for (i in 1:perm_ct){diff.perm[i] <- mean(perm1[i,]) - mean(perm2[i,])}
    diff.obs <- mean(sample1) - mean(sample2) 
  }
  else if (method == 'median') {
    for (i in 1:perm_ct){diff.perm[i] <- median(perm1[i,]) - median(perm2[i,])}
    diff.obs <- median(sample1) - median(sample2) 
  }
  else {print('Invalid alternative'); diff.obs = NULL}
  
  
  if (alternative == 'two.sided') {
    p.val <- sum(abs(diff.perm) >= abs(diff.obs))/choose(m+n,m)
  }
  else if (alternative == 'greater') {
    p.val <- sum(diff.perm >= diff.obs)/choose(m+n,m)
  }
  else if (alternative == 'less') {
    p.val <- sum(diff.perm <= diff.obs)/choose(m+n,m)
  }
  else {print('Invalid alternative'); p.val = NULL}
  
  return(list(test.stat = diff.obs, p.value = p.val, alternative = alternative))
}