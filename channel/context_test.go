package channel


func coordinateWithContext() {
	total := 12
	var num int32
	fmt.Printf("The number: %d [with context.Context]\n", num)
	cxt, cancelFunc := context.WithCancel(context.Background())
	
	for i := 1; i <= total; i++ {
	 go addNum(&num, i, func() {
	  if atomic.LoadInt32(&num) == int32(total) {
	   cancelFunc()
	  }
	 })
	}
	<-cxt.Done()
	fmt.Println("End.")
   }

func TestContext(t *testing.T){

}