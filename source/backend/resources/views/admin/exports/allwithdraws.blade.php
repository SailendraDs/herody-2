<table>
    <thead>
    <tr>
        <th>User</th>
        <th>Amount</th>
        <th>Mode</th>
        <th>Status</th>
        <th>Created At</th>
    </tr>
    </thead>
    <tbody>
    @foreach($wrs as $wr)
    <?php $user = \App\User::find($wr->user_id); ?>
    @if($user)
        <tr>
            <td>{{ $user->email }}</td>
            <td>{{ $wr->amount }}</td>
            <td>{{ $wr->mode }}</td>
            <td>{{ $wr->status===0?"Pending":($wr->status===1?"Accepted":($wr->status===2?"Rejected":"")) }}</td>
            <td>{{ $wr->created_at }}</td>
        </tr>
    @endif
    @endforeach
    </tbody>
</table>