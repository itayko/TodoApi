FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
#COPY *.sln .
#COPY TodoApi/*.csproj ./TodoApi/
COPY TodoApi.csproj .
COPY *.json ./

RUN dotnet restore

# Copy everything else and build app
#COPY TodoApi/. ./TodoApi/
COPY . ./

#WORKDIR /app/TodoApi
#RUN dotnet publish -c Release -o out
RUN dotnet publish -c Release -o /app/out
RUN ls /app


FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS runtime
WORKDIR /app
#COPY --from=build-env /app/out ./
COPY --from=build /app/out ./


RUN if [ ! -f "/TodoApi/bin/Release/netcoreapp3.0/TodoApi.dll" ]; then echo "File not found!"; fi

EXPOSE 80
ENTRYPOINT ["dotnet", "TodoApi.dll"]