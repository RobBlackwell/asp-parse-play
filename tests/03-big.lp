% Define some numbers
num(1..5).

% Define "big" numbers as those greater than 3
big(X) :- num(X), X > 3.

#show big/1.
