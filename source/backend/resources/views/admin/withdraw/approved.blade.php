@extends('admin.master')

@section('title', 'Admin | Approved Withdrawals')

@section('body')

    <div class="container-fluid">
        <h2 class="mb-4">Approved Withdrawals</h2>

        <div class="card mb-4">
            <div class="card-header bg-white font-weight-bold">
                Withdrawals
            </div>
            <div class="card-body">
                @if($withdrawals->count()===0)
                <p>No Data Found.</p>
                @else
                <table class="table  table-striped table-bordered">
                    <thead>
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">User</th>
                        <th scope="col">Amount</th>
                        <th scope="col">Mode</th>
                    </tr>
                    </thead>
                    <tbody>

                    @foreach($withdrawals as $withdraw)
                        <tr>
                            <th scope="row">{{$loop->iteration}}</th>
                            <td>{{$withdraw->user->name}}</td>
                            <td>{{$withdraw->amount}}</td>
                            <td>{{$withdraw->mode}}</td>
                        </tr>
                    @endforeach

                    </tbody>
                </table>
                @endif
                {{$withdrawals->links()}}
            </div>
        </div>
    </div>
    {{--dropdown active--}}
    <script>
        $('#Withdraw li:nth-child(2)').addClass('active');
        $('#Withdraw').addClass('show');
    </script>
@endsection