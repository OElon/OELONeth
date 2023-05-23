// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./OELONSwap.sol";

interface IERC20 {
    function getBalance(address owner) external view returns (uint);
}

interface IWETH {
    function deposit() external payable;
    function transferTokens(address to, uint256 value) external returns (bool);
    function withdraw(uint) external;
}

interface IUniV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    function getTokenName() external view returns (string memory);
    function getTokenSymbol() external view returns (string memory);
    function getDecimals() external view returns (uint8);
    function getTotalSupply() external view returns (uint);
    function getBalanceOf(address owner) external view returns (uint);
    function getAllowance(address owner, address spender) external view returns (uint);
    function approveExternal(address spender_, uint256 value) external returns (bool);
    function transferExternal(address recipient, uint256 value) external returns (bool);
    function transferFromExternal(address from, address to, uint value) external returns (bool);
    function nonces(address owner) external view returns (uint);
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function initialize(address, address) external;
}

interface IUniV2Router {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
}

interface IOELON {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event HopEvt(uint256 indexed fxOut, uint256 indexed weiIn);
    event LqtyEvt(uint256 indexed fxOut, uint256 indexed weiOut);
    event MktgEvt(uint256 indexed weiOut);
    event ChtyEvt(uint256 indexed weiOut);
    event SetFees(
        uint16 indexed ttlFeePctBuys,
        uint16 indexed ttlFeePctSells,
        uint8 ethPtnChty,
        uint8 ethPtnMktg,
        uint8 tknPtnLqty,
        uint8 ethPtnLqty,
        uint8 ethPtnRwds
    );
    event ExcludeFromFees(address indexed account);
    event ExcludeFromRewards(address indexed account);
    event SetBlacklist(address indexed account, bool indexed toggle);
    event SetLockerUnlockDate(uint32 indexed oldUnlockDate, uint32 indexed newUnlockDate);
    event SetMinClaimableDivs(uint64 indexed newMinClaimableDivs);
    event LockerExternalAddLiquidityETH(uint256 indexed fxTokenAmount);
    event LockerExternalRemoveLiquidityETH(uint256 indexed lpTokenAmount);
    event XClaim(address indexed user, uint256 indexed amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function tokenName() external view returns (string memory);
    function tokenSymbol() external view returns (string memory);
    function tokenDecimals() external view returns (uint8);
    function getBalance(address account) external view returns (uint256);
    function getTokenTotalSupply() external view returns (uint72);
    function getXTotalSupply() external view returns (uint72);
    function transferTokens(address recipient, uint256 amount) external returns (bool);
    function transferTokensFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function approveSpender(address spender, uint256 amount) external returns (bool);
    function getAllowance(address owner, address spender) external view returns (uint256);
    function increaseAllowanceBy(address spender, uint256 addedValue) external returns (bool);
    function decreaseAllowanceBy(address spender, uint256 subtractedValue) external returns (bool);
    function getUniswapV2Pair() external view returns (address);
    function getUniswapV2Router() external view returns (address);
    function getOELONSwapAddress() external view returns (address);
    function getConfigData() external view returns (
        uint64 hopThreshold,
        uint64 lqtyThreshold,
        uint32 lockerUnlockDate,
        uint16 xGasForClaim,
        uint64 xMinClaimableDivs,
        bool tradingEnabled,
        uint16 ttlFeePctBuys,
        uint16 ttlFeePctSells,
        uint16 ethPtnChty,
        uint16 ethPtnMktg,
        uint16 tknPtnLqty,
        uint16 ethPtnLqty,
        uint16 ethPtnRwds
    );
    function xGetDivsAvailableData(address acct) external view returns (uint256);
    function xGetDivsEarnedToDateData(address acct) external view returns (uint256);
    function xGetDivsWithdrawnToDateData(address account) external view returns (uint88);
    function withdrawCharityFundsExternal(address payable charityBeneficiary) external;
    function withdrawMarketingFundsExternal(address payable marketingBeneficiary) external;
    function lockerAdvanceLockExternal(uint32 nSeconds) external;
    function lockerExternalAddLiquidityETHExternal(uint256 fxTokenAmount) external payable;
    function lockerExternalRemoveLiquidityETHExternal(uint256 lpTokenAmount) external;
    function activateExternal() external;
    function setHopThresholdExternal(uint64 tokenAmt) external;
    function setLqtyThresholdExternal(uint64 weiAmt) external;
    function setAutomatedMarketMakerPairExternal(address pairAddr, bool toggle) external;
    function excludeFromFeesExternal(address account) external;
    function excludeFromRewardsExternal(address account) external;
    function setBlackListExternal(address account, bool toggle) external;
    function setGasForClaimExternal(uint16 newGasForClaim) external;
    function burnOwnerTokensExternal(uint256 amount) external;
    function renounceOwnershipExternal() external;
    function transferOwnershipExternal(address newOwner) external;
    function xClaimExternal() external;
    function fxAddAirdropExternal(
        address[] calldata accts,
        uint256[] calldata addAmts,
        uint256 tsIncrease,
        uint256 xtsIncrease
    ) external;
    function fxSubAirdropExternal(
        address[] calldata accts,
        uint256[] calldata subAmts,
        uint256 tsDecrease,
        uint256 xtsDecrease
    ) external;
}

//function swapExactTokensForETHSFOTT(uint amountIn) external;_rem
//function lockerExternalRemoveLiquidityETHReceiver(uint256 lpTokenAmount, address _owner) external;
//}

contract OELON is IOELON {
    struct AcctInfo {
        uint256 balance;
        uint256 xDivsAvailable;
        uint256 xDivsEarnedToDate;
        uint256 xDivsWithdrawnToDate;
        bool isAMMPair;
        bool isBlackListedBot;
        bool isExcludedFromRwds;
        bool isExcludedFromFees;
    }

    struct Config {
        uint256 hopThreshold;
        uint256 lqtyThreshold;
        uint32 lockerUnlockDate;
        uint256 xGasForClaim;
        uint256 xMinClaimableDivs;
        uint256 ttlFeePctBuys;
        uint256 ttlFeePctSells;
        uint256 ethPtnChty;
        uint256 ethPtnMktg;
        uint256 tknPtnLqty;
        uint256 ethPtnLqty;
        uint256 ethPtnRwds;
        bool tradingEnabled;
    }

    Config public config;

    struct LockerParams {
        uint32 nSeconds;
        uint256 fxTokenAmount;
        uint256 lpTokenAmount;
    }

    uint256 public xDivsPerShare;
    uint72 private _totalSupply;
    uint72 private _xTotalSupply;
    uint88 public xDivsGlobalTotalDist;
    uint8 private constant _FALSE = 1;
    uint8 private constant _TRUE = 2;
    uint8 public sellEvtEntrancy;
    uint136 private constant xMagnitude = 2**128;
    uint48 private constant xMinForDivs = 100000 * (10**9);
    uint72 private mars_HOPPING_POWER;
    uint72 private mars_ES_CHTY_MUSK;
    uint72 private mars_ES_MKTG_MUSK;
    uint72 private mars_ES_LQTY_MUSK;
    uint64 private mars_TS_LQTY_MUSK;
    address private _owner;
    IUniV2Router private UniV2Router;
    IUniV2Pair private UniV2Pair;
    IWETH private WETH;
    OELONSwap private oelonSwap;

    mapping(address => AcctInfo) internal _a;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => int256) private xDivsCorrections;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the contract owner can call this function.");
        _;
    }

    constructor(address routerAddress, uint72 initLqtyAmt) {
        _owner = msg.sender; // Assign the contract creator as the owner
        _totalSupply = 0; // Initialize total supply to 0
        _transferOwnership(msg.sender);
        sellEvtEntrancy = _FALSE;
        setConfigValues();
        initializeUniswap(routerAddress);
        createUniswapPair();
        excludeFromFees();
        mintInitialTokens(initLqtyAmt);
    }

    function excludeFromDividends() internal {
        address[] memory excludedAddresses = new address[](6);
        excludedAddresses[0] = address(UniV2Pair);
        excludedAddresses[1] = address(this);
        excludedAddresses[2] = address(oelonSwap);
        excludedAddresses[3] = address(UniV2Router);
        excludedAddresses[4] = address(0x000000000000000000000000000000000000dEaD);
        excludedAddresses[5] = _owner;

        for (uint256 i = 0; i < excludedAddresses.length; i++) {
            _a[excludedAddresses[i]].isExcludedFromFees = true;
            _a[excludedAddresses[i]].isExcludedFromRwds = true;
        }
    }

    function setConfigValues() internal {
        config = Config(
            100_000_000 * (10**9), // hopThreshold: 100mn fx
            25 * (10**16), // lqtyThreshold: .25 eth
            uint32(block.timestamp), // lockerUnlockDate: current block timestamp
            3000, // xGasForClaim: 3000
            600_000_000_000_000, // xMinClaimableDivs: about 5.5 USD at the time of deployment
            500, // ttlFeePctBuys: 500
            800, // ttlFeePctSells: 800
            20, // ethPtnChty: 20
            10, // ethPtnMktg: 10
            6, // tknPtnLqty: 6
            9, // ethPtnLqty: 9
            40, // ethPtnRwds: 40
            true // tradingEnabled: true
        );
    }

    function initializeUniswap(address routerAddress) internal {
        UniV2Router = IUniV2Router(routerAddress);
        WETH = IWETH(UniV2Router.WETH());
    }

    function updateAMMPair(address pairAddr) public onlyOwner {
        _a[pairAddr].isAMMPair = true;
    }

    function createUniswapPair() internal {
        address contractAddress = address(0x000000000000000000000000000000000000dEaD);
        address pairAddr = IUniV2Factory(UniV2Router.factory()).createPair(contractAddress, address(WETH));
        UniV2Pair = IUniV2Pair(pairAddr);
        _a[pairAddr].isAMMPair = true;
        oelonSwap = new OELONSwap(contractAddress, UniV2Router, pairAddr, WETH);
    }

    function mintInitialTokens(uint72 initLqtyAmt) internal {
        _totalSupply += initLqtyAmt;
        _a[_owner].balance += uint128(initLqtyAmt);
    }
}
    
  function setExcludedFromFees(address account) internal {
        _a[account].isExcludedFromFees = true;
    }

    function excludeFromFeesExternal() external {
        _a[address(this)].isExcludedFromFees = true;
        _a[address(oelonSwap)].isExcludedFromFees = true;
    }

 // Add this closing brace to properly close the excludeFromFeesExternal function


function withdrawCharityFunds(address payable charityBeneficiary) {
    require(charityBeneficiary != address(0), "zero address disallowed");
    emit ChtyEvt(mars_ES_CHTY_MUSK);
    (bool success,) = charityBeneficiary.call{value: mars_ES_CHTY_MUSK}("");
    require(success, "call to beneficiary failed");
    mars_ES_CHTY_MUSK = 0;
}

function withdrawMarketingFunds(address payable marketingBeneficiary) {
    require(marketingBeneficiary != address(0), "zero address disallowed");
    emit MktgEvt(mars_ES_MKTG_MUSK);
    (bool success,) = marketingBeneficiary.call{value: mars_ES_MKTG_MUSK}("");
    require(success, "call to beneficiary failed");
    mars_ES_MKTG_MUSK = 0;
}


function _transfer(address from, address to, uint256 amount) {
    require(_a[from].balance >= amount, "insuff. balance for transfer");

    Config memory c = config;
    require(amount > 0, "amount must be above zero");
    require(from != address(0), "from cannot be zero address");
    require(to != address(0), "to cannot be zero address");
    require(!_a[to].isBlackListedBot, "nobots");
    require(!_a[msg.sender].isBlackListedBot, "nobots");
    require(!_a[from].isBlackListedBot, "nobots");

    uint txType = _a[from].isAMMPair ? 0 : _a[to].isAMMPair ? 1 : 2;

    require(c.tradingEnabled || msg.sender == _owner, "tradingEnabled hardstop");

    if (txType == 1 && sellEvtEntrancy != _TRUE) {
        sellEvtEntrancy = _TRUE;
        if (mars_ES_LQTY_MUSK >= c.lqtyThreshold) {
            if (mars_TS_LQTY_MUSK == 0) {
                mars_ES_MKTG_MUSK += uint72(mars_ES_LQTY_MUSK);
                mars_ES_LQTY_MUSK = 0;
            } else {
                lockerInternalAddLiquidityETHBlind(mars_TS_LQTY_MUSK, mars_ES_LQTY_MUSK);
                mars_TS_LQTY_MUSK = 0;
                mars_ES_LQTY_MUSK = 0;
                emit LqtyEvt(mars_TS_LQTY_MUSK, mars_ES_LQTY_MUSK);
            }
        } else {
            uint HOPPING_POWER = mars_HOPPING_POWER;
            if (HOPPING_POWER >= c.hopThreshold) {
                uint _ethPtnTotal = c.ethPtnChty + c.ethPtnMktg + c.ethPtnLqty + c.ethPtnRwds;
                uint _ovlPtnTotal = _ethPtnTotal + c.tknPtnLqty;
                uint magLqTknPct = (uint(c.tknPtnLqty) * 10000) / _ovlPtnTotal;
                uint lqtyTokenAside = (HOPPING_POWER * magLqTknPct) / 10000;
                mars_TS_LQTY_MUSK += uint64(lqtyTokenAside);

                _transferSuper(address(this), address(UniV2Pair), HOPPING_POWER - lqtyTokenAside);
                OELONSwap oelonSwapInstance = OELONSwap(payable(0x1234567890123456789012345678901234567890));
                uint createdEth = oelonSwapInstance.swapExactTokensForETHSFOTT();

                emit HopEvt(HOPPING_POWER, createdEth);

                uint mars_ES_CHTY = (createdEth * c.ethPtnChty) / _ethPtnTotal;
                uint mars_ES_MKTG = (createdEth * c.ethPtnMktg) / _ethPtnTotal;
                uint mars_ES_LQTY = (createdEth * c.ethPtnLqty) / _ethPtnTotal;
                uint mars_ES_RWDS = createdEth - mars_ES_CHTY - mars_ES_MKTG - mars_ES_LQTY;

                xDivsPerShare += ((mars_ES_RWDS * xMagnitude) / _xTotalSupply);
                xDivsGlobalTotalDist += uint88(mars_ES_RWDS);

                mars_ES_CHTY_MUSK += uint72(mars_ES_CHTY);
                mars_ES_MKTG_MUSK += uint72(mars_ES_MKTG);
                mars_ES_LQTY_MUSK += uint72(mars_ES_LQTY);

                mars_HOPPING_POWER = 0;
            }
        }
        sellEvtEntrancy = _FALSE;
    }

    if (
        txType != 2 &&
        !_a[from].isExcludedFromFees &&
        !_a[to].isExcludedFromFees
    ) {
        uint feePct = txType == 0 ? c.ttlFeePctBuys : c.ttlFeePctSells;
        uint feesAmount = (amount * feePct) / 10000;
        amount -= feesAmount;
        mars_HOPPING_POWER += uint72(feesAmount);
        xBurn(from, feesAmount);
        _transferSuper(from, address(this), feesAmount);
    }

    xBurn(from, amount);
    xMint(to, amount);
    _transferSuper(from, to, amount);

    xProcessAccount(payable(from));
    xProcessAccount(payable(to));
}
function xClaim() {
        xProcessAccount(payable(msg.sender));
    }

    function fxAddAirdrop(
        address[] accts, uint256[] addAmts,
        uint256 tsIncrease, uint256 xtsIncrease
    ) {
        require(_owner == msg.sender && !config.tradingEnabled, "onlyOwner and pre-launch");
        for (uint256 i = 0; i < accts.length; i++) {
            _a[accts[i]].balance += uint128(addAmts[i]);
        }
        _totalSupply += uint72(tsIncrease);
        _xTotalSupply += uint72(xtsIncrease);
    }

    function fxSubAirdrop(
        address[] accts, uint256[] subAmts,
        uint256 tsDecrease, uint256 xtsDecrease
    ) {
        require(_owner == msg.sender && !config.tradingEnabled, "onlyOwner and pre-launch");
        for (uint256 i = 0; i < accts.length; i++) {
            _a[accts[i]].balance -= uint128(subAmts[i]);
        }
        _totalSupply -= uint72(tsDecrease);
        _xTotalSupply -= uint72(xtsDecrease);
    }

/* END transfer() */

/* BEGIN LOCKER & LIQUIDITY OPS */
function lockerAdvanceLock(uint32 nSeconds) {
    uint32 oldUnlockDate = config.lockerUnlockDate;
    uint32 newUnlockDate = oldUnlockDate + nSeconds;
    config.lockerUnlockDate = newUnlockDate;
    emit SetLockerUnlockDate(oldUnlockDate, newUnlockDate);
}

function lockerExternalAddLiquidityETH(uint256 fxTokenAmount) payable {
    require(fxTokenAmount > 0 && msg.value > 0, "must supply both fx and eth");
    _transferSuper(_owner, address(this), fxTokenAmount);
    address payable oelonSwapAddress = payable(address(oelonSwap));
    lockerInternalAddLiquidityETHBlind(fxTokenAmount, msg.value); // Call the updated function
    emit LockerExternalAddLiquidityETH(fxTokenAmount);
}

function lockerExternalRemoveLiquidityETH(uint256 lpTokenAmount) {
    require(config.lockerUnlockDate < block.timestamp, "unlockDate not yet reached");
    require(UniV2Pair.balanceOf(address(this)) >= lpTokenAmount, "not enough lpt held by contract");
    address payable oelonSwapAddress = payable(address(oelonSwap));
    UniV2Pair.approve(oelonSwapAddress, lpTokenAmount);
    OELONSwap(oelonSwapAddress).lockerExternalRemoveLiquidityETHReceiver(lpTokenAmount, _owner);
    emit LockerExternalRemoveLiquidityETH(lpTokenAmount);
}

function lockerInternalAddLiquidityETHBlind(uint256 fxTokenAmount, uint256 weiAmount) {
    address addrWETH = address(WETH);
    address addrFlowx = address(this);
    (uint rsvFX, uint rsvETH,) = UniV2Pair.getReserves();
    if (addrFlowx > addrWETH) {
        (rsvFX, rsvETH) = (rsvETH, rsvFX);
    }
    uint amountA;
    uint amountB;
    if (rsvFX == 0 && rsvETH == 0) {
        (amountA, amountB) = (fxTokenAmount, weiAmount);
    } else {
        uint amountADesired = fxTokenAmount;
        uint amountBDesired = weiAmount;
        uint amountBOptimal = (amountADesired * rsvETH) / rsvFX;
        if (amountBOptimal <= amountBDesired) {
            (amountA, amountB) = (amountADesired, amountBOptimal);
        } else {
            uint amountAOptimal = (amountBDesired * rsvFX) / rsvETH;
            require(amountAOptimal <= amountADesired, "optimal liquidity calc failed");
            (amountA, amountB) = (amountAOptimal, amountBDesired);
        }
    }
    _transferSuper(addrFlowx, address(UniV2Pair), amountA);
    WETH.deposit{value: weiAmount}();
    require(WETH.transfer(address(UniV2Pair), weiAmount), "failed WETH xfer to lp contract");
    UniV2Pair.mint(addrFlowx);
}
/* END LOCKER & LIQUIDITY OPS */
  /* BEGIN FX GENERAL CONTROLS */
  function activate() {
    config.tradingEnabled = true;
}

function setHopThreshold(uint64 tokenAmt) {
    require(tokenAmt >= (10 * (10**9)), "out of accepted range");
    require(tokenAmt <= (2_000_000_000 * (10**9)), "out of accepted range");
    config.hopThreshold = tokenAmt;
}

function setLqtyThreshold(uint64 weiAmt) {
    require(weiAmt >= 100, "out of accepted range");
    config.lqtyThreshold = weiAmt;
}

function setFees(
    uint16 _ttlFeePctBuys, uint16 _ttlFeePctSells,
    uint8 _ethPtnChty, uint8 _ethPtnMktg, uint8 _tknPtnLqty,
    uint8 _ethPtnLqty, uint8 _ethPtnRwds
) {
    require(
        _ttlFeePctBuys >= 10 && _ttlFeePctBuys <= 1000 &&
        _ttlFeePctSells >= 10 && _ttlFeePctSells <= 1600,
        "Fee pcts out of accepted range"
    );
    require(
        ((_tknPtnLqty > 0 && _ethPtnLqty > 0) || (_tknPtnLqty == 0 && _ethPtnLqty == 0)) &&
        _ethPtnChty <= 100 &&
        _ethPtnMktg <= 100 &&
        _tknPtnLqty <= 100 &&
        _ethPtnLqty <= 100 &&
        _ethPtnRwds <= 100,
        "Portions outside accepted range"
    );
    config.ttlFeePctBuys = _ttlFeePctBuys;
    config.ttlFeePctSells = _ttlFeePctSells;
    config.ethPtnChty = _ethPtnChty;
    config.ethPtnMktg = _ethPtnMktg;
    config.tknPtnLqty = _tknPtnLqty;
    config.ethPtnLqty = _ethPtnLqty;
    config.ethPtnRwds = _ethPtnRwds;
    emit SetFees(_ttlFeePctBuys, _ttlFeePctSells, _ethPtnChty, _ethPtnMktg, _tknPtnLqty, _ethPtnLqty, _ethPtnRwds);
}

function setAutomatedMarketMakerPair(address pairAddr, bool toggle) {
    require(pairAddr != address(UniV2Pair), "original pair is constant");
    require(_a[pairAddr].isAMMPair != toggle, "setting already exists");
    _a[pairAddr].isAMMPair = toggle;
    if (toggle && !_a[pairAddr].isExcludedFromRwds) {
        IOELON oelonInstance = IOELON(0x1234567890123456789012345678901234567890); // Replace with the actual contract address
        oelonInstance.excludeFromRewards(pairAddr);
    }
}
function excludeFromFees(address account) {
    require(!_a[account].isExcludedFromFees, "already excluded");
    _a[account].isExcludedFromFees = true;
    emit ExcludeFromFees(account);
}

function excludeFromRewards(address account) {
    require(!_a[account].isExcludedFromRwds, "already excluded");
    _a[account].isExcludedFromRwds = true;
    xProcessAccount(payable(account));
    if (_a[account].balance > xMinForDivs) {
        _xTotalSupply -= uint72(_a[account].balance);
        delete xDivsCorrections[account];
    }
    emit ExcludeFromRewards(account);
}

function setBlackList(address account, bool toggle) {
    if (toggle) {
        require(
            account != address(UniV2Router) &&
            account != address(UniV2Pair) &&
            account != address(oelonSwap) &&
            account != _owner,
            "ineligible for blacklist"
        );
        _a[account].isBlackListedBot = true;
    } else {
        _a[account].isBlackListedBot = false;
    }
    emit SetBlacklist(account, toggle);
}

function setGasForClaim(uint16 newGasForClaim) {
    require(newGasForClaim > 3000, "not enough gasForClaim");
    config.xGasForClaim = newGasForClaim;
}

function setMinClaimableDivs(uint64 newMinClaimableDivs) {
    require(newMinClaimableDivs > 0, "out of accepted range");
    config.xMinClaimableDivs = newMinClaimableDivs;
    emit SetMinClaimableDivs(newMinClaimableDivs);
}

function getConfig() view returns (
    uint64 _hopThreshold, uint64 _lqtyThreshold, uint32 _lockerUnlockDate,
    uint16 _xGasForClaim, uint64 _xMinClaimableDivs, bool _tradingEnabled,
    uint16 _ttlFeePctBuys, uint16 _ttlFeePctSells,
    uint16 _ethPtnChty, uint16 _ethPtnMktg, uint16 _tknPtnLqty,
    uint16 _ethPtnLqty, uint16 _ethPtnRwds
) {
    Config memory c = config;
    return (
        c.hopThreshold, c.lqtyThreshold, c.lockerUnlockDate,
        c.xGasForClaim, c.xMinClaimableDivs, c.tradingEnabled,
        c.ttlFeePctBuys, c.ttlFeePctSells,
        c.ethPtnChty, c.ethPtnMktg, c.tknPtnLqty,
        c.ethPtnLqty, c.ethPtnRwds
    );
}

function getAccount(address account) view returns (AccountData memory) {
    return AccountData(
        _a[account].balance,
        _a[account].xDivsAvailable,
        _a[account].xDivsEarnedToDate,
        _a[account].xDivsWithdrawnToDate,
        _a[account].isAMMPair,
        _a[account].isBlackListedBot,
        _a[account].isExcludedFromRwds,
        _a[account].isExcludedFromFees
    );
}

function xGetDivsAvailable(address acct) view returns (uint256) {
    return xDivsAvailable(acct);
}

function xGetDivsEarnedToDate(address acct) view returns (uint256) {
    return xDivsEarnedToDate(acct);
}

function xGetDivsWithdrawnToDate(address account) view returns (uint88) {
    return uint88(_a[account].xDivsWithdrawnToDate);
}

function xGetDivsGlobalTotalDist() view returns (uint88) {
    return xDivsGlobalTotalDist;
}

function getUniV2Pair() view returns (address) {
    return address(UniV2Pair);
}

function getUniV2Router() view returns (address) {
    return address(UniV2Router);
}

function getOELONSwap() view returns (address) {
    return address(oelonSwap);
}

function burnOwnerTokens(uint256 amount) {
    _burn(msg.sender, amount);
}

  /*********BEGIN ERC20**********/
function name() pure returns (string memory) { return "Oelon"; }
function symbol() pure returns (string memory) { return "OELON"; }
function decimals() pure returns (uint8) { return 9; }
function owner() view returns (address) { return _owner; }
function totalSupply() view returns (uint72) { return _totalSupply; }
function xTotalSupply() view returns (uint72) { return _xTotalSupply; }

function balanceOf(address account) view returns (uint256) {
  return uint256(_a[account].balance);
}

function transfer(address recipient, uint256 amount) returns (bool) {
  _transfer(msg.sender, recipient, amount);
  return true;
}

function allowance(address owner_, address spender_) view returns (uint256) {
  return _allowances[owner_][spender_];
}

function approve(address spender, uint256 amount) returns (bool) {
  _approve(msg.sender, spender, amount);
  return true;
}

function transferFrom(address sender, address recipient, uint256 amount) returns (bool) {
  _transfer(sender, recipient, amount);
  uint256 currentAllowance = _allowances[sender][msg.sender];
  require(currentAllowance >= amount, "amount exceeds allowance");
  unchecked {
    _approve(sender, msg.sender, currentAllowance - amount);
  }
  return true;
}

function increaseAllowance(address spender, uint256 addedValue) returns (bool) {
  _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
  return true;
}

function decreaseAllowance(address spender, uint256 subtractedValue) returns (bool) {
  uint256 currentAllowance = _allowances[msg.sender][spender];
  require(currentAllowance >= subtractedValue, "decreased allowance below zero");
  unchecked {
    _approve(msg.sender, spender, currentAllowance - subtractedValue);
  }
  return true;
}

function _transferSuper(address sender, address recipient, uint256 amount) {
    require(sender != address(0), "transfer from the zero address");
    require(recipient != address(0), "transfer to the zero address");
    uint256 senderBalance = _a[sender].balance;
    require(senderBalance >= amount, "transfer amount exceeds balance");
    unchecked {
        _a[sender].balance = uint128(senderBalance - amount);
    }
    _a[recipient].balance += uint128(amount);
    emit Transfer(sender, recipient, amount);
}

function _burn(address account, uint256 amount) {
    require(account != address(0), "burn from the zero address");
    uint256 accountBalance = _a[account].balance;
    require(accountBalance >= amount, "burn amount exceeds balance");
    unchecked {
        _a[account].balance = uint128(accountBalance - amount);
    }
    _totalSupply -= uint72(amount);
    emit Transfer(account, address(0), amount);
}

function _approve(address owner_, address spender_, uint256 amount) {
    require(owner_ != address(0), "approve from zero address");
    require(spender_ != address(0), "approve to zero address");
    _allowances[owner_][spender_] = amount;
    emit Approval(owner_, spender_, amount);
}

/*********END ERC20**********/

/*********BEGIN OWNABLE**********/
function renounceOwnership() {
    _transferOwnership(address(0));
}

function transferOwnership(address newOwner) {
    require(newOwner != address(0), "OELON: no zero address");
    require(newOwner != address(_owner), "OELON: already owner");
    _transferOwnership(newOwner);
}

function _transferOwnership(address newOwner) {
    address oldOwner = _owner;
    _a[newOwner].isExcludedFromRwds = true;
    _a[newOwner].isExcludedFromFees = true;
    _owner = newOwner;
    emit OwnershipTransferred(oldOwner, newOwner);
}
/*********END OWNABLE**********/

/*********REWARDS FUNCTIONALITY**********/

function xDivsAvailable(address acct) view returns (uint256) {
  return xDivsEarnedToDate(acct) - uint256(_a[acct].xDivsWithdrawnToDate);
}

function xDivsEarnedToDate(address acct) view returns (uint256) {
  uint256 currShare =
    (_a[acct].isExcludedFromRwds || _a[acct].balance < xMinForDivs) ? 0 : _a[acct].balance;
  return uint256(int256(xDivsPerShare * currShare) + xDivsCorrections[acct]) / xMagnitude;
}

// xMint MUST be called BEFORE intended updates to balances
function xMint(address acct, uint256 mintAmt) {
  if (!_a[acct].isExcludedFromRwds) {
    uint256 acctSrcBal = _a[acct].balance;
    if ((acctSrcBal + mintAmt) > xMinForDivs) {
      mintAmt += (acctSrcBal < xMinForDivs) ? acctSrcBal : 0;
      _xTotalSupply += uint72(mintAmt);
      xDivsCorrections[acct] -= int256(xDivsPerShare * mintAmt);
    }
  }
}

// xBurn MUST be called BEFORE intended updates to balances
function xBurn(address acct, uint256 burnAmt) {
  if (!_a[acct].isExcludedFromRwds) {
    uint256 acctSrcBal = _a[acct].balance;
    if (acctSrcBal > xMinForDivs) {
      uint256 acctDestBal = acctSrcBal - burnAmt;
      burnAmt += (acctDestBal < xMinForDivs) ? acctDestBal : 0;
      _xTotalSupply -= uint72(burnAmt);
      xDivsCorrections[acct] += int256(xDivsPerShare * burnAmt);
    }
  }
}

function xProcessAccount(address payable account) returns (bool successful) {
  uint256 divsAvailable = xDivsAvailable(account);
  if (divsAvailable > config.xMinClaimableDivs) {
    _a[account].xDivsWithdrawnToDate += uint88(divsAvailable);
    emit XClaim(account, divsAvailable);
    (bool success, ) = account.call{value: divsAvailable, gas: config.xGasForClaim}("");
    if (success) {
      return true;
    } else {
      _a[account].xDivsWithdrawnToDate -= uint88(divsAvailable);
      return false;
    }
  } else {
    return false;
  }
}


