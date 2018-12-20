package main

import "fmt"

var rules = []int64{7, 5, 16, 5, 16, 1, 1, 2, 16, 1, 8, 1, 9, 2, 1, 3, 6, 3, 4, 3, 8, 3, 5, 5, 7, 5, 1, 5, 8, 2, 0, 0, 7, 1, 1, 1, 3, 1, 4, 3, 8, 5, 3, 5, 16, 2, 6, 5, 7, 2, 1, 2, 3, 2, 4, 3, 8, 3, 5, 5, 16, 1, 2, 5, 9, 5, 5, 5, 7, 4, 2, 4, 9, 4, 4, 4, 9, 5, 4, 4, 10, 4, 11, 4, 7, 3, 2, 3, 9, 3, 5, 3, 7, 3, 13, 3, 8, 4, 3, 4, 8, 5, 0, 5, 16, 0, 8, 5, 15, 5, 5, 3, 9, 3, 5, 3, 8, 5, 3, 3, 9, 5, 3, 3, 10, 3, 14, 3, 9, 3, 5, 3, 8, 4, 3, 4, 16, 0, 9, 0, 16, 0, 9, 5}

func addToRegister(opcode int64, a int64, b int64, c int64, register []int64) []int64 {

  if opcode == 1 {
    if a > register[b] {
      register[c] = 1
    } else {
      register[c] = 0
    }
  }

  if opcode == 2 {
    if register[a] > b {
      register[c] = 1
    } else {
      register[c] = 0
    }
  }

  if opcode == 3 {
    if register[a] > register[b] {
      register[c] = 1
    } else {
      register[c] = 0
    }
  }

  if opcode == 4 {
    if a == register[b] {
      register[c] = 1
    } else {
      register[c] = 0
    }
  }

  if opcode == 5 {
    if register[a] == b {
      register[c] = 1
    } else {
      register[c] = 0
    }
  }

  if opcode == 6 {
    if register[a] == register[b] {
      register[c] = 1
    } else {
      register[c] = 0
    }
  }

  if opcode == 7 {
    register[c] = register[a]+b
  }

  if opcode == 8 {
    register[c] = register[a]+register[b]
  }

  if opcode == 9 {
    register[c] = register[a]*register[b]
  }

  if opcode == 10 {
    register[c] = register[a]*b
  }

  if opcode == 11 {
    register[c] = register[a]&register[b]
  }

  if opcode == 12 {
    register[c] = register[a]&b
  }

  if opcode == 13 {
    register[c] = register[a]|register[b]
  }

  if opcode == 14 {
    register[c] = register[a]|b
  }

  if opcode == 15 {
    register[c] = register[a]
  }

  if opcode == 16 {
    register[c] = a
  }

  register[5] += 1
  return register
}

func PrimeFactors(n int64) (pfs []int64) {
  // Get the number of 2s that divide n
  for n%2 == 0 {
    pfs = append(pfs, 2)
    n = n / 2
  }

  // n must be odd at this point. so we can skip one element
  // (note i = i + 2)
  for i := int64(3); i*i <= n; i = i + 2 {
    // while i divides n, append i and divide n
    for n%i == 0 {
      pfs = append(pfs, i)
      n = n / i
    }
  }

  // This condition is to handle the case when n is a prime number
  // greater than 2
  if n > 2 {
    pfs = append(pfs, n)
  }

  return
}

func main() {
  // 1
  register := []int64{0,0,0,0,0,0}

  for {
    if register[5] > int64(len(rules))/int64(4) {
      break
    }
    opcode, a, b, c := rules[register[5]*int64(4)], rules[register[5]*int64(4)+1], rules[register[5]*int64(4)+2], rules[register[5]*int64(4)+3]
    register = addToRegister(opcode, a, b, c, register)
  }

  fmt.Println(register[0])

  // 2

  // [0, 0, 0, 10550400, 10551293, 35]
  // sum of divisors of register 4

  v := int64(10551293)
  sum := int64(0)
  for _, p := range PrimeFactors(v) {
    sum += p
  }
  fmt.Println(int64(1)+v+sum)
}