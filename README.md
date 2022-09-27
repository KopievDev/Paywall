# Paywall

``` swift
   @IBAction private func clickAnswer(_ sender: UIButton) {
        let currentQuest = questions[currentQuestionIndex]
        var answerQuestion = Bool()
        
        switch sender.tag {
        case 0:
            answerQuestion = false
        case 1:
            answerQuestion = true
        default:
            break
        }
        
        if answerQuestion == currentQuest.correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
```
Рефакторинг
``` swift
   @IBAction private func clickAnswer(_ sender: UIButton) {
        let currentQuest = questions[currentQuestionIndex]
        let answerQuestion = sender.tag == 1 
        showAnswerResult(isCorrect: answerQuestion == currentQuest.correctAnswer)
    }
```
