
(defrule combine-certainties
   ?fact1 <- (attribute (name ?name) (value ?value) (certainty ?certainty1))
   ?fact2 <- (attribute (name ?name) (value ?value) (certainty ?certainty2))
   (test (neq ?fact1 ?fact2))
   =>
   (retract ?fact1)
   (modify ?fact2 (certainty (/ (- (* (+ ?certainty1 ?certainty2) 100) (* ?certainty1 ?certainty2)) 100))))

(defrule select-beers
   (declare (salience ?*medium-low-priority*))
   (or (and (beer (name ?beer-name))
            (attribute (name best-name) (value ?beer-name) (certainty ?certainty)))
       (and (beer (name ?beer-name) (style ?beer-style))
            (attribute (name best-style) (value ?beer-style) (certainty ?certainty)))
       (and (beer (name ?beer-name) (alcohol $? ?alcohol $?))
            (attribute (name best-alcohol) (value ?alcohol) (certainty ?certainty)))
       (and (beer (name ?beer-name) (color $? ?color $?))
            (attribute (name best-color) (value ?color) (certainty ?certainty)))
       (and (beer (name ?beer-name) (flavor $? ?flavor $?))
            (attribute (name best-flavor) (value ?flavor) (certainty ?certainty)))
       (and (beer (name ?beer-name) (fermentation $? ?fermentation $?))
            (attribute (name best-fermentation) (value ?fermentation) (certainty ?certainty)))
       (and (beer (name ?beer-name) (carbonation $? ?carbonation $?))
            (attribute (name best-carbonation) (value ?carbonation) (certainty ?certainty))))
   =>
   (assert (attribute (name beer) (value ?beer-name) (certainty ?certainty))))

(defrule remove-poor-beer-choices
   ?fact <- (attribute (name beer) (certainty ?certainty&:(< ?certainty 49)))
   =>
   (retract ?fact))

(defrule remove-best-attributes
   (declare (salience ?*low-priority*))
   ?fact <- (attribute (name ?name&:(neq ?name beer)))
   =>
   (retract ?fact))

(defrule print-results
   (declare (salience ?*very-low-priority*))
   (UI-state (id ?id))
   (state-list (current ?id))
   =>
   (bind ?beers "")
   (do-for-all-facts ((?a attribute) (?b beer))
                     (and (eq ?a:name beer)
                          (eq ?a:value ?b:name))
                     (and (retract ?a)
                          (bind ?beers (str-cat ?beers (format nil "🍺 [%s - %s](%s) with certainty %-2d%% %n"
                                                                   ?b:style ?b:name ?b:link ?a:certainty)))))
   (if (neq ?beers "")
    then (bind ?results (str-cat (format nil "%s %n%n" "*✅ Done. I have selected these beer styles for you.*") ?beers))
    else (bind ?results (format nil "%s %n%n%s" "*🚫 Sorry! I could not select any beer style for you. 😞"
                                               "Please, try again! 💪🏻*")))
   (assert (UI-state (display ?results)
                     (state final))))
