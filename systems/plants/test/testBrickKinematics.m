function testBrickKinematics
warning('off','RigidBodyManipulator:collisionDetect:doKinematicsMex');
warning('off','Drake:TaylorVar:DoubleConversion');
for fb = {'rpy','RPY'};%,'quat'};
  options.floating = fb{1};
  m = RigidBodyManipulator('FallingBrick.urdf',options);
  
  nq=getNumPositions(m);
  for i=1:25
    q = randn(nq,1); qd = randn(nq,1);
    options.grad_method = {'user','taylorvar'};
    [x,J] = geval(1,@terrainContactPositions,m,q,options);
    
    options.grad_method = 'taylorvar';
    [x,J,dJ] = geval(1,@terrainContactPositions,m,q,options);
    kinsol = doKinematics(m,q,true,false,qd);
    [~,~,Jdot] = terrainContactPositions(m,kinsol,true);
    valuecheck(Jdot,matGradMult(reshape(dJ,numel(x)*nq,nq),qd));
  end
end


end
