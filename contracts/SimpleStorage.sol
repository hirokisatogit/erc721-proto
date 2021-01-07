pragma solidity 0.6.2;

contract SimpleStorage {
  string ipfsHash;

  struct Ipfs {
    string _ipfsHash;
  }

  event createIpfsHash (
    string ipfsHash
  );

  Ipfs[] public IpfsHash;

  function set(string memory _ipfsHash) public {
    ipfsHash = _ipfsHash;
    IpfsHash.push(Ipfs(ipfsHash));
    emit createIpfsHash(ipfsHash);
  }

  function get() public view returns (string memory) {
    return ipfsHash;
  }

  function arraylength() public view returns (uint) {
    return IpfsHash.length;
  }
}