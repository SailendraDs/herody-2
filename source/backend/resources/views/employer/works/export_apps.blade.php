<table>
    <thead>
    <tr>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Created At</th>
    </tr>
    </thead>
    <tbody>
    @foreach($gigs as $gig)
    <?php $user = \App\User::find($gig->uid); ?>
    @if($user)
        <tr>
            <td>{{ $user->name }}</td>
            <td>{{ $user->email }}</td>
            <td>{{ $user->phone }}</td>
            <td>{{ $gig->created_at }}</td>
        </tr>
    @endif
    @endforeach
    </tbody>
</table>