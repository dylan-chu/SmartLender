contract Smartlender {
   
    enum State { Open, Requested, Approved }
    State public state;

    address borrower;
    address lender;

    uint totalColAmt;
    uint requestTime;
    uint minCancelReqTime;
    uint minLoanAmtReq;
    uint loanAmt;
    uint approvalTime;
    uint endTime;
    uint reqPayAmt;
    bytes32 payConfirmMsg;
    uint paidAmt;
        
    struct Collateral {
        uint assetAmt;
    }
   
    mapping(address => Collateral) assets;

    modifier onlyOpen(State _state ) { if (_state == State.Open) _ else throw; }
    modifier onlyRequested( State _state ) { if (_state == State.Open || _state == State.Approved) throw; _ }
    modifier onlyApproved( State _state ) { if (_state == State.Open || _state == State.Requested) throw; _ }
    modifier onlyNotApproved(State _state) { if (_state == State.Approved) throw; _ }
    modifier onlyBorrower( address _addr ) { if (_addr != borrower ) throw; _ }
    modifier onlyLender( address _addr ) { if (_addr != lender ) throw; _ }
    
    
    function Smartlender () {
        address borrower = msg.sender;
        state = State.Open;
    }
   
    function collateralizeFunds () 
        onlyNotApproved(state) {
            Collateral colAssets = assets[msg.sender];
            colAssets.assetAmt += msg.value;
            totalColAmt += msg.value;
    }
    
   
    function unfreezeCollateral () 
        // define conditions for asset release
        onlyOpen(state) {
            Collateral colAssets = assets[msg.sender];
            var amt = colAssets.assetAmt;
            colAssets.assetAmt = 0;
            totalColAmt -= amt;
            
            if (!msg.sender.send( amt ))
                throw;
    }
    
   
    function requestLoan(address lndr, uint minCancelTime, uint mLoanAmt ) 
        onlyBorrower( msg.sender )
        onlyNotApproved( state ) {
            state = State.Requested;
            lender = lndr;
            minLoanAmtReq = mLoanAmt;
            minCancelReqTime = minCancelTime;
            requestTime = now;
    }
    
   
   function cancelRequest() 
       onlyBorrower( msg.sender )
       onlyRequested( state ) {
       if ( now > requestTime + minCancelReqTime ) {
            lender = address(0);
            state = State.Open;
       }
       
    }
   
    function getTotalCollateralAmt() constant returns (uint ttlColAmt) {
        if ( msg.sender != borrower && msg.sender != lender )
            throw;
            
        ttlColAmt = totalColAmt; 
    }
    
    function approveLoan(uint lnAmt, uint loanTime)
        onlyLender(msg.sender) 
        onlyRequested( state ) {
            if ( loanAmt < minLoanAmtReq ) throw;
            loanAmt = lnAmt;
            state = State.Approved;
            approvalTime = now;
            endTime = approvalTime + loanTime;
    }
    
    function requestPayment( uint amt, bytes32 payConfirm ) 
        onlyLender( msg.sender )
        onlyApproved( state ) {
            reqPayAmt = amt;
            payConfirmMsg = payConfirm;        
    }
    
    function payLoan( uint paymentAmt, bytes32 payKey ) 
        onlyBorrower( msg.sender )
        onlyApproved( state ) {
            if ( sha3( payKey ) != payConfirmMsg ) throw;
            paidAmt += paymentAmt;    
    }
    
    function confiscateCollateral () 
        // define conditions for the lender to confiscate the collateral
        onlyLender( msg.sender )
        onlyApproved( state ) {
        if ( now > endTime && paidAmt < loanAmt ) {
		totalColAmt = 0;
            	if ( address(lender).send(totalColAmt) != true ) throw;  
        }
    }
   
} 
