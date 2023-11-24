;;; You can use this to cut down on some of the spurious errors that SBCL produces
(declaim (sb-ext:muffle-conditions cl:warning))

(defun comma-split (string)
  (loop for start = 0 then (1+ finish)
        for finish = (position #\, string :start start)
        collecting (subseq string start finish)
        until (null finish)))

;;; Here is a function definition to read a file and print the contents
(defun read-file ( filename ) (
                               with-open-file (stream filename)
                               ;;; Use this variable to store the sting you read in for parsing
                               (defvar line 0)
                               ;;; Now start reading each line 
                               (loop for i from 0 to 5 do
                                     ( setf line ( read-line stream))
                                     ;;; Print out the contents of the file
                                     ( princ line ) (terpri)
                                         ( loop for j from 0 to 4 do
                                            ( if ( string-equal ( subseq ( nth j (comma-split line)) 0 2) "10" )
                                                 (progn 
                                                   ( princ (subseq ( nth j (comma-split line)) 0 2) )
                                                   ( princ " ")
                                                   ( princ (subseq ( nth j (comma-split line)) 2 3) )
                                                   ( princ " ") )
                                                 (progn
                                                   ( princ (subseq ( nth j (comma-split line)) 1 2) )
                                                   ( princ " ")
                                                   ( princ (subseq ( nth j (comma-split line)) 2 3) )
                                                   ( princ " ") )
                                            )

                                     )
                                     (terpri)

                                     )
                               ))


;;; Command line argument processing in SBCL uses the sb-ext:*posix-argv* extension
(if (= (length sb-ext:*posix-argv*) 2)
    (defvar usehandsets T) (defvar usehandsets (not T)))


(if usehandsets
    (progn
      ( princ "*** USING TEST DECK ***" ) (terpri) (terpri)
      ( defvar handsetfile (second sb-ext:*posix-argv*))
      ( princ "*** File: ")
      ( princ handsetfile ) (terpri)
      ( read-file handsetfile )
      (terpri)
      )  ;;; end of test deck prep

    ( progn
      ( princ "*** CODE FOR RANDOMIZED DECK NEEDED  ***" ) (terpri)

      )
    ) 