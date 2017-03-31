--Levelution Pluricell

function c30039202.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c30039202.spcon)
	c:RegisterEffect(e1)
	-- discard opponent or self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30039202,0))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,30039202)
	e2:SetTarget(c30039202.target)
	e2:SetOperation(c30039202.operation)
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

end


function c30039202.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x12F)
end
function c30039202.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c30039202.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c30039202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=0
	if chk==0 then return b1 or b2 end
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(30039202,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(30039202,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,tp,1)
		elseif sel==2 then
		e:SetCategory(CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
	end
	end
function c30039202.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()==0 then return end
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.Damage(tp,1000,REASON_EFFECT)
	elseif sel==2 then
		local g=Duel.GetFieldGroup(1-tp,0,LOCATION_HAND)
		if g:GetCount()>0 then
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
