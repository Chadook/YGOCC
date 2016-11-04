--Umbral Trap Hole
function c99830044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Destroy after 3 Special Summons
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99830044,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(99830044)
	e2:SetCost(c99830044.cost)
	e2:SetTarget(c99830044.target)
	e2:SetOperation(c99830044.operation)
	c:RegisterEffect(e2)
	if not c99830044.global_check then
		c99830044.global_check=true
		c99830044[0]=0
		c99830044[1]=0
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge:SetOperation(c99830044.checkop)
		Duel.RegisterEffect(ge,0)
	end
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99830044,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c99830044.destg)
	e3:SetOperation(c99830044.desop)
	c:RegisterEffect(e3)
end
function c99830044.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()~=c99830044[2] then
		c99830044[0]=0
		c99830044[1]=0
		c99830044[2]=Duel.GetTurnCount()
	end
	local tc=eg:GetFirst()
	local p1=false
	while tc do
		if tc:GetSummonPlayer()==1-tp then p1=true end
		tc=eg:GetNext()
	end
	if p1 then
		c99830044[1-tp]=c99830044[1-tp]+1
		if c99830044[1-tp]>=3 then
			Duel.RaiseEvent(e:GetHandler(),99830044,e,0,0,0,0)
		end
	end
end
function c99830044.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function c99830044.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c99830044.target(e,tp,eg,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99830044.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c99830044.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c99830044.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99830044.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c99830044.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99830044.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end