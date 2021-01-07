pragma solidity 0.6.2;

import "node_modules/@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract ERC1155Certificate is ERC1155("test") {
  using SafeMath for uint; // SafeMathはOpenZeppelinのコントラクトであり、ここでuintにする事で安全な数学演算をサポートしている

  uint256 internal certificateId = 0;
  mapping (address => uint[]) public myCertificateId; // myCertificateIdは誰が何のIDを持ってるかを全て取る為に作ったもので、mappingによって引数にアドレスを与えるとuint[]が返ってくる仕様
  // mapping (uint256 => address) public certificateIssuer; // operatorが用意されているからいらないかも

  struct Certificate {
    uint256 id;
    string nameOfCertificate;
    bytes ipfsHash;
    address issuer;
    uint256 issuetime;
  }

  Certificate[] public certificates;

  constructor() public { }

  function issueCertificate(string calldata _nameOfCertificate, uint256 numberOfCertificate, address[] calldata _toAddresses, bytes calldata _data) external {
    certificateId = certificateId.add(1); // 6行目のSafeMathを使っておりNFTを発行している 1を足しているのはデフォルトの使い方
    _mint(msg.sender, certificateId, numberOfCertificate, _data); // 証明証を発行している部分 OpenZeppelin参照
    certificates.push(Certificate(certificateId, _nameOfCertificate, _data, msg.sender, now)); // Certificateを用いて一つ一つ代入し、certificatesにプッシュしている
    for (uint i = 0; i < numberOfCertificate; i++ ) {
      safeTransferFrom(msg.sender, _toAddresses[i], certificateId, 1, _data); // safeTransferFromは持っている引数をそれぞれのアドレスに送っているもの OpenZeppelin参照
      myCertificateId[_toAddresses[i]].push(certificateId); // 送る人の証明証のidを送り先のアドレスと紐付けている
    }
  }

  function getMyCertificateId(address _certificateHolder) external view returns (uint[] memory) {
    return myCertificateId[_certificateHolder]; // アドレスをuint[]にしてから、IDとして返している
  }

}