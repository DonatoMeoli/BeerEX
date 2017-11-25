
(load clips/beerex.clp)

(deffunction ask-question (?display ?allowed-values)
   (bind ?answer "")
   (while (not (member ?answer ?allowed-values))
      (printout t ?display " " ?allowed-values " ")
      (bind ?answer (readline))
      (if (eq (str-index " " ?answer) FALSE)
       then (bind ?answer (nth$ 1 (explode$ ?answer)))))
   ?answer)

(deffunction next-UI-state ()
   (do-for-fact ((?s state-list)) TRUE (and (bind ?current-id ?s:current)
                                            (bind ?sequence ?s:sequence)))
   (do-for-fact ((?u UI-state)) (eq ?u:id ?current-id) (and (bind ?display ?u:display)
                                                            (bind ?help ?u:help)
                                                            (bind ?why ?u:why)
                                                            (bind ?state ?u:state)
                                                            (bind ?valid-answers ?u:valid-answers)))
   (if (eq ?state initial)
    then (assert (next ?current-id))
         (run)
         (next-UI-state))
   (if (eq ?state middle)
    then (if (> (length$ ?sequence) 2)
          then (bind ?answer
                     (ask-question ?display (insert$ ?valid-answers (+ (length$ ?valid-answers) 1) help why prev cancel)))
          else (bind ?answer
                     (ask-question ?display (insert$ ?valid-answers (+ (length$ ?valid-answers) 1) help why cancel)))))
   (if (eq ?state final)
    then (bind ?answer (ask-question ?display (create$ prev restart cancel))))

   (if (member$ ?answer ?valid-answers)
    then (assert (next ?current-id ?answer))
         (run)
         (next-UI-state))
   (if (eq ?answer help)
    then (printout t ?help crlf)
         (next-UI-state))
   (if (eq ?answer why)
    then (printout t ?why crlf)
         (next-UI-state))
   (if (eq ?answer prev)
    then (assert (prev ?current-id))
         (run)
         (next-UI-state))
   (if (eq ?answer cancel)
    then (reset)))

(reset)
(run)

(next-UI-state)
