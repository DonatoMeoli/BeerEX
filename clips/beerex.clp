
;;;==========================================================
;;; BeerEX: the Beer EXpert system
;;;
;;;   This expert system suggests a beer to drink with a meal.
;;;
;;;   For use with BeerEX.bot.py
;;;
;;;   CLIPS Version 6.30
;;;
;;;   Author: Donato Meoli
;;;===========================================================


;;; ****************
;;; * DEFTEMPLATES *
;;; ****************

(deftemplate UI-state
   (slot id
      (default-dynamic (gensym*)))
   (slot display)
   (slot relation-asserted
      (default none))
   (slot response
      (default none))
   (multislot valid-answers)
   (slot state
      (default middle)))

(deftemplate state-list
   (slot current)
   (multislot sequence))

(deftemplate attribute
   (slot name)
   (slot value)
   (slot certainty
      (default 100.0)))

(deftemplate beer
   (slot style
      (type STRING)
      (allowed-strings "Pale Ale" "Dark Lager" "Brown Ale" "India Pale Ale" "Wheat Beer" "Strong Ale"
                       "Belgian Style" "Hybrid Beer" "Porter" "Stout" "Bock" "Scottish-Style Ale"
                       "Wild/Sour" "Pilsener & Pale Lager" "Specialty Beer"))
   (slot name
      (type STRING))
   (multislot alcohol
      (type SYMBOL)
      (allowed-symbols not-detectable mild noticeable harsh))
   (multislot color
      (type SYMBOL)
      (allowed-symbols pale amber brown dark))
   (multislot flavor
      (type SYMBOL)
      (allowed-symbols crisp-clean malty-sweet dark-roasty hoppy-bitter fruity-spicy sour-tart-funky))
   (multislot fermentation
      (type SYMBOL)
      (allowed-symbols top bottom wild))
   (multislot carbonation
      (type SYMBOL)
      (allowed-symbols low medium high))
   (slot link
      (type STRING)))

;;***************************
;;* DEFFACTS & STARTUP RULE *
;;***************************

(deffacts startup
   (state-list))

(defrule system-banner
  =>
  (load-facts "./clips/beer-styles.clp")
  (load "./clips/beer-questions.clp")
  (load "./clips/beer-knowledge.clp")
  (load "./clips/beer-selection.clp")
  (load "./clips/gui-interaction.clp")
  (set-strategy random)
  (assert (UI-state (display (format nil "%n%s %n%n%s %n%n%s" "Welcome to the Beer EXpert system 🍻️"
                                         (str-cat "⁉️ All I need is that you answer simple questions by choosing "
                                                  "one of the responses that are offered to you.")
                                         "To start, please press the /new button 😄"))
                    (relation-asserted start)
                    (state initial))))