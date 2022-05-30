@extends('layouts.authApp')
@section('title',config('app.name').' | Wallet')
@section('content')
<section class="section">
	<div class="container">
		<div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="page-head">
                    <h2>Wallet</h2>
                </div>
            </div>
			<div class="col-lg-10">
				<div class="rounded shadow bg-white p-4">
					<div class="custom-form">
						<h2 id="message3">Wallet</h2>
                        <h5>Amount: {{$user->balance}}</h5>
                        <button data-toggle="modal" data-target="#withdraw" class="btn btn-success btn-inline btn-sm">Withdraw</button>
                        <a class="btn btn-info btn-inline btn-sm" href="{{route("user.wallet.accounts")}}">Accounts</a>
					</div>
				</div>
				<div class="rounded shadow bg-white p-4 mt-2">
					<div class="custom-form">
						<h2 id="message3">Transactions</h2>
                        @if($transactions->count()===0)
                        <p>You haven't made any transaction yet.</p>
                        @else
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Transaction ID</th>
                                    <th>Amount</th>
                                    <th>Reason</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach ($transactions as $transaction)
                                    <tr>
                                        <td>{{$transaction->transaction_id}}</td>
                                        <td><span class="badge badge-{{$transaction->type==="INC"?"success":"danger"}}">{{$transaction->type==="INC"?"+":"-"}} {{$transaction->amount}} INR</span></td>
                                        <td>{{$transaction->reason}}</td>
                                        <td>{{\Carbon\Carbon::parse($transaction->created_at)->diffForHumans()}}</td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                        @endif
                        {{$transactions->links()}}
					</div>
				</div>
				<div class="rounded shadow bg-white p-4 mt-2">
					<div class="custom-form">
						<h2 id="message3">Withdrawals</h2>
                        @if($withdrawals->count()===0)
                        <p>You haven't made any withdrawals yet.</p>
                        @else
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Mode</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach ($withdrawals as $withdrawal)
                                    <tr>
                                        <td>{{$withdrawal->amount}}</td>
                                        <td><span class="badge badge-{{$withdrawal->status===0?"info":($withdrawal->status===1?"success":($withdrawal->status===2?"danger":""))}}">{{$withdrawal->status===0?"Pending":($withdrawal->status===1?"Approved":($withdrawal->status===2?"Rejected":""))}}</span></td>
                                        <td>{{$withdrawal->mode}}</td>
                                        <td>{{\Carbon\Carbon::parse($withdrawal->created_at)->diffForHumans()}}</td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                        @endif
                        {{$transactions->links()}}
					</div>
				</div>
			</div>
		</div>
	</div>
</section>

<div class="modal fade" id="withdraw" tabindex="-1" role="dialog" aria-labelledby="withdraw">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="withdrawLabel">Add Money</h4>
            </div>
                <div class="modal-body">
                    <form action="{{route("user.wallet.withdraw")}}" method="post">
                        @csrf
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="amount">Amount</label>
                                    <input type="number" class="form-control" name="amount" placeholder="Amount">
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="mode">Mode</label>
                                    @if($user->bank_acc_id===NULL and $user->upi_acc_id===NULL)
                                    <p>You have not added any account details yet. Please add atleast one to continue.</p>
                                    @endif
                                    @if($user->bank_acc_id!==NULL)
									<div class="custom-control custom-radio custom-control-block">
										<div class="form-group">
											<input type="radio" id="bank" value="IMPS" name="mode" class="custom-control-input">
											<label class="custom-control-label" for="bank">Bank</label>
										</div>
									</div>
                                    @endif
                                    @if($user->upi_acc_id!==NULL)
									<div class="custom-control custom-radio custom-control-block">
										<div class="form-group">
											<input type="radio" id="upi" value="UPI" name="mode" class="custom-control-input">
											<label class="custom-control-label" for="upi">UPI</label>
										</div>
									</div>
                                    @endif
                                </div>
                            </div>
                            <div class="col-md-12">
                                <button class="btn btn-primary">Withdraw</button>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection