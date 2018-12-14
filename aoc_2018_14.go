package main

import "fmt"

var newArr = []int64{3,7}
var L = int64(513401)
var elf1idx = int64(0)
var elf2idx = int64(1)
var length = int64(2)
var star1Solved bool

func main() {
  for {
    elf1Steps := newArr[elf1idx]+int64(1)
    elf2Steps := newArr[elf2idx]+int64(1)
    sum := newArr[elf1idx]+newArr[elf2idx]
    numArr := []int64{}
    if sum == 0 {
      newArr = append(newArr, 0)
    } else {
      for sum > 0 {
        mod := sum % 10
        numArr = append([]int64{mod}, numArr...)
        sum /= 10
      }
      for _, n := range numArr {
        newArr = append(newArr, n)
      }
    }  
    length = int64(len(newArr))

    // 1

    if length >= L+10 && !star1Solved {
      fmt.Println(newArr[length-10:length])
      star1Solved = true
    }
    
    // 2

    if (length >= 6 && newArr[length-6] == 5 &&  newArr[length-5] == 1 && newArr[length-4] == 3 && newArr[length-3] == 4 && newArr[length-2] == 0 && newArr[length-1] == 1) {
      fmt.Println(length-6)
      break
    }
    if (length >= 7 && newArr[length-7] == 5 &&  newArr[length-6] == 1 && newArr[length-5] == 3 && newArr[length-4] == 4 && newArr[length-3] == 0 && newArr[length-2] == 1) {
      fmt.Println(length-7)
      break
    }

    elf1idx = (elf1idx+elf1Steps) % length
    elf2idx = (elf2idx+elf2Steps) % length

  }
}