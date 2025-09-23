resource "aws_guardduty_detector" "us-east-2" {
  provider = aws.us-east-2

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "us-east-1" {
  provider = aws.us-east-1

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "us-west-1" {
  provider = aws.us-west-1

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "us-west-2" {
  provider = aws.us-west-2

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "ap-east-1" {
  provider = aws.ap-east-1

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "ap-south-1" {
  provider = aws.ap-south-1

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "ap-northeast-3" {
  provider = aws.ap-northeast-3

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "ap-northeast-2" {
  provider = aws.ap-northeast-2

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}


resource "aws_guardduty_detector" "ap-southeast-1" {
  provider = aws.ap-southeast-1

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "ap-southeast-2" {
  provider = aws.ap-southeast-2

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "ap-northeast-1" {
  provider = aws.ap-northeast-1

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "ca-central-1" {
  provider = aws.ca-central-1

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "eu-central-1" {
  provider = aws.eu-central-1

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "eu-west-1" {
  provider = aws.eu-west-1

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "eu-west-2" {
  provider = aws.eu-west-2

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "eu-west-3" {
  provider = aws.eu-west-3

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "eu-north-1" {
  provider = aws.eu-north-1

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}

resource "aws_guardduty_detector" "sa-east-1" {
  provider = aws.sa-east-1

  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }
}