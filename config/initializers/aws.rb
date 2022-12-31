aws_confg = { region: 'ap-northeast-1',
              access_key_id: Rails.application.credentials.aws_access_key.access_key_id,
              secret_access_key: Rails.application.credentials.aws_access_key.secret_access_key }

s3_resource = Aws::S3::Resource.new(aws_confg)
IMAGE_S3 = s3_resource.bucket('nyumyanyamyumya-article-image')
