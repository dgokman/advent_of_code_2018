package main

import "fmt"

var rules = []int64{16, 123, 0, 4, 12, 4, 456, 4, 5, 4, 72, 4, 8, 4, 3, 3, 16, 0, 0, 3, 16, 0, 6, 4, 14, 4, 65536, 5, 16, 1855046, 9, 4, 12, 5, 255, 2, 8, 4, 2, 4, 12, 4, 16777215, 4, 10, 4, 65899, 4, 12, 4, 16777215, 4, 1, 256, 5, 2, 8, 2, 3, 3, 7, 3, 1, 3, 16, 27, 0, 3, 16, 0, 9, 2, 7, 2, 1, 1, 10, 1, 256, 1, 3, 1, 5, 1, 8, 1, 3, 3, 7, 3, 1, 3, 16, 25, 5, 3, 7, 2, 1, 2, 16, 17, 0, 3, 15, 2, 7, 5, 16, 7, 9, 3, 6, 4, 0, 2, 8, 2, 3, 3, 16, 5, 3, 3}

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

  register[3] += 1
  return register
}


func main() {
  register := []int64{1,0,0,0,0,0}
  for {
    opcode, a, b, c := rules[register[3]*int64(4)], rules[register[3]*int64(4)+1], rules[register[3]*int64(4)+2], rules[register[3]*int64(4)+3]

    // 1
    if opcode == 6 // eqrr 4 0 2 is the only rule that uses register 0 {
      fmt.Println(register[4])
      break 
      // 2
      // Removed break and found a repeating pattern of 1427 numbers ending with 3715167
    }
    register = addToRegister(opcode, a, b, c, register)

  }
}
