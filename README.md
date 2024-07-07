# TipCalculator

#  MVVM: Model View ViewModel

## **MVVM and UIKit**

**Model**  
Not really used here, since it's a simple app. The two files in models are not really models in true MVVM style.  
Why? Because they don't define or represent the data that the View and ViewModel will use.

**View** = UIViewController in our case.  
As dumb as possible. Should only contain the UI.

**ViewModel**  
The brain, contains all the business logic.

## **How to implement MVVM with UIKit?**
1. Create a ViewModel class.
2. Create Input (what the VM should get from the VC, such as actions) and Output (what the VM should give to the VC, such as results) structs.
3. We add a `transform` (or configure) method that gets an `Input` and returns `Output`. This is where the processing of data gets done, i.e. based on the input, we generate the output.
4. Instantiate the `ViewModel` inside the `UIViewController`.
5. Create a `bindViewModel()` method that gets called in the init of the VC, that calls VM's `transform` method and handles the signals from the output (what should be done from the view's side for the output).
6. Create all views inside the VC.
