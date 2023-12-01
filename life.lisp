(defpackage :life
    (:use :common-lisp :sketch)
    (:export :main)
)
(in-package :life)

; Grid parameters 
(defconstant cols 50)
(defconstant rows 50)
(defconstant cell-size 10)
(defconstant time-delta 0.05)
; Pens
(defconstant pen-dead (make-pen :fill +white+))
(defconstant pen-alive (make-pen :fill +black+))

(defsketch life (
        ; Define local variables
        (grid (make-array (list rows cols) :initial-element nil)) ; Logical game grid
        (active nil) ; Is the simulation active?
        ; Set window properties
        (title "Game of life")
        (width (* cols cell-size))
        (height (* rows cell-size))
        (pos (cons 0 0)))
        ; Main loop
            ; If active, run simulation logic
        (when active
            (let ((next (make-array (list rows cols) :initial-element nil))) ; Clear next grid
                (dotimes (x cols)
                    (dotimes (y rows)
                        (let ((neighbors 0))
                            ; Loop through all neighbors (including the current cell) and add any alive cells to neighbors
                            (loop for x-offset from -1 to 1
                                do (loop for y-offset from -1 to 1
                                    do (when (and (< (+ x x-offset) cols) (<= 0 (+ x x-offset)) (< (+ y y-offset) rows) (<= 0 (+ y y-offset)))
                                        (if (aref grid (+ y y-offset) (+ x x-offset))
                                            (incf neighbors)))))     
                            (let ((cell (aref grid y x)))
                                (when cell (decf neighbors)) ; If current cell alive, decrement neighbors
                                (cond 
                                    ((and cell (< neighbors 2)) (setf (aref next y x) nil)) ; Kill cell if is alive and has <2 neighbors
                                    ((and cell (> neighbors 3)) (setf (aref next y x) nil)) ; Kill cell if is alive and has >3 neighbors
                                    ((and (not cell) (= neighbors 3)) (setf (aref next y x) t)) ; Create cell if is dead and has exactly 3 neighbors
                                    (t (setf (aref next y x) cell))))))) ; Else the cell remains the same
            (setq grid next)) ; Update grid
          (sleep time-delta)) 
        ; Draw the grid to the window
        (dotimes (x cols)
            (dotimes (y rows)
                (let ((pen (if (aref grid y x) (symbol-value 'pen-alive) (symbol-value 'pen-dead))))
                    (with-pen pen (rect (* x cell-size) (* y cell-size) cell-size cell-size)))))
)

; On mouse button down: toggles the clicked cell
(defmethod kit.sdl2:mousebutton-event ((window life) state timestamp button x y)
    (with-slots (grid) window
        (when (eq state :mousebuttondown)
            (setf (aref grid (floor (/ y cell-size)) (floor (/ x cell-size))) (not (aref grid (floor (/ y cell-size)) (floor (/ x cell-size))))))))

; On keyboard input: pauses/unpauses the simulation
(defmethod kit.sdl2:textinput-event ((window life) timestamp text)
    (with-slots (active) window
        (setf active (not active))))

(defun main () 
    (make-instance 'life)
)

; Loops indefinitely to not instantly close when run as an executable
(defun main-executable ()
    (make-instance 'life)
    (loop))