function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Compute the hidden layer A1
X = [ ones(m,1) X ];
Z2 = Theta1 * X';
A2 = sigmoid( Z2 );

% Compute the output layer H
A2 = [ ones(1,m) ; A2 ];
Z3 = Theta2 * A2;
H = sigmoid( Z3 );

% Compute the cost
%   Reformat y into binary vectors:
yVecs = zeros( num_labels, m );
for i = 1:m,
    yVecs(y(i), i) = 1;
end;
%   Compute the base cost
J = -sum( sum(  yVecs.*log( H )  +  (1-yVecs).*log( 1 - H )  ) ) / m;
%   Add the regularization terms to the cost
regTerm = lambda * ( sum(sum( Theta1(:,2:end).^2 )) + sum(sum( Theta2(:,2:end).^2 )) ) / (2*m);
J += regTerm;


% BACKPROPAGATION
% Compute the output errors
Delta3 = H - yVecs;

% Compute the hidden layer errors
Z2 = [ ones(1,m) ; Z2 ];
Delta2 = ( Theta2' * Delta3 ) .* sigmoidGradient( Z2 );

% Accumulate Theta2 gradients
Theta2_grad = Delta3 * A2';

% Accumulate Theta1 gradients
Theta1_grad = Delta2(2:end, :) * X;

% Compute final unregularized gradients
Theta2_grad = Theta2_grad / m;
Theta1_grad = Theta1_grad / m;

% Regularize the gradients
Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) + ( lambda * ( Theta2(:, 2:end) / m ) );
Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) + ( lambda * ( Theta1(:, 2:end) / m ) );

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
